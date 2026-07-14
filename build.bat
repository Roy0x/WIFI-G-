@echo off
REM Build WiFi Guardian into a standalone Windows executable (dist/WiFiGuardian/).
pyinstaller --name WiFiGuardian --onedir --windowed --clean ^
  --hidden-import=src.config --hidden-import=src.scanner --hidden-import=src.safety ^
  --hidden-import=src.vendor --hidden-import=src.tests --hidden-import=src.logger ^
  --hidden-import=src.settings --hidden-import=src.protection ^
  --hidden-import=ui.worker --hidden-import=ui.details_panel --hidden-import=ui.settings_dialog ^
  --hidden-import=ui.tools_dialog --hidden-import=ui.log_view ^
  main.py
