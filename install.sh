#!/usr/bin/env bash

# Set all install directories to the user's home directory
applications_dir="${HOME}/.local/share/applications/"
icons_dir="${HOME}/.local/share/icons/hicolor/scalable/apps/"
bin_dir="${HOME}/.local/bin/"
# These system directories are targeted by specific commands later
udev_dir="/etc/udev/rules.d/"
systemd_dir="${HOME}/.config/systemd/user/"

# Files to install
bin_files=("dist/arctis-manager" "dist/arctis-manager-launcher")
systemd_service_file="systemd/arctis-manager.service"
udev_rules_file="udev/91-steelseries-arctis.rules"
desktop_file="ArctisManager.desktop"
icon_file="arctis_manager/images/steelseries_logo.svg"

function install() {
    echo "Installing Arctis Manager for the current user..."

    # Create local directories
    mkdir -p "${bin_dir}"
    mkdir -p "${applications_dir}"
    mkdir -p "${icons_dir}"
    mkdir -p "${systemd_dir}"

    echo "Running pyinstaller to generate binary files..."
    # These commands will be run inside a distrobox container
    python3 -m pip install --user --upgrade pipenv
    python3 -m pipenv install -d
    python3 -m pipenv run pyinstaller arctis-manager.spec
    python3 -m pipenv run pyinstaller arctis-manager-launcher.spec
    python3 -m pipenv --rm

    echo "Installing binaries in ${bin_dir}"
    for file in "${bin_files[@]}"; do
        dest_file="${bin_dir}/$(basename "${file}")"
        cp "${file}" "${dest_file}"
    done

    echo "Installing desktop file in ${applications_dir}"
    dest_file="${applications_dir}/$(basename "${desktop_file}")"
    cp "${desktop_file}" "${dest_file}"

    echo "Installing icon file in ${icons_dir}"
    dest_file="${icons_dir}/arctis_manager.svg"
    cp "${icon_file}" "${dest_file}"

    echo "Installing systemd user service..."
    cp "${systemd_service_file}" "${systemd_dir}"

    echo "Installation of files complete."
    echo "Please handle Udev rules and enable the systemd service on your host system (outside the container)."
}

# The uninstall function is left similar for cleanup if needed
function uninstall() {
    echo "Uninstalling Arctis Manager..."
    echo
    echo "Removing udev rules. This requires sudo."
    sudo rm -f "${udev_dir}/$(basename ${udev_rules_file})"
    echo "Removing user systemd service."
    systemctl --user disable --now "$(basename ${systemd_service_file})" 2>/dev/null
    rm -f "${systemd_dir}/$(basename ${systemd_service_file})"
    echo "Removing desktop file."
    rm -f "${applications_dir}/$(basename ${desktop_file})"
    echo "Removing icon file."
    rm -f "${icons_dir}/arctis_manager.svg"
    echo "Removing application binaries."
    for file in "${bin_files[@]}"; do
        rm -f "${bin_dir}/$(basename "${file}")"
    done
}

if [[ -v UNINSTALL ]]; then
    uninstall
else
    install
fi
