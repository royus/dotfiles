# Windows setup script
# Run this script to apply automated settings.

Write-Host "Applying Windows settings..."

# 1. Dark Mode Setup (System & Apps)
Write-Host "Setting Dark Mode..."
New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0 -PropertyType DWord -Force | Out-Null

# 2. Show seconds in taskbar clock (Windows 11)
Write-Host "Enabling seconds in taskbar clock..."
New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSecondsInSystemClock" -Value 1 -PropertyType DWord -Force | Out-Null

# Restart explorer to apply taskbar changes (Requires manual restart)
Write-Host "Please restart Explorer or log out/in to apply taskbar changes."

Write-Host "Done."
