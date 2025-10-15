# -*- mode: python ; coding: utf-8 -*-

# This line is essential for PyInstaller to find the PyQt6 libraries.
hiddenimports = ['PyQt6', 'PyQt6.sip']

a = Analysis(
    ['arctis_manager.py'],
    pathex=['.'],
    binaries=[],
    datas=[
    ('arctis_manager/images/steelseries_logo.svg', 'arctis_manager/images/'),
    ('arctis_manager/lang/*.json', 'arctis_manager/lang/'),
    ('/usr/lib64/python3.13/site-packages/PyQt6/Qt6/plugins/platforms', 'PyQt6/Qt6/plugins/platforms')
    ],
    hiddenimports=hiddenimports,
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name='arctis-manager',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
