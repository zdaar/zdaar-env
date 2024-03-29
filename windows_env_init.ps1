# Check if we are admin, if not, exit
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    [System.Windows.Forms.Messagebox]::Show("This script needs to be run as administrator !");
}

# Install Fonts

echo "Install fonts"
$fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)
foreach ($file in Get-ChildItem ./envFonts/*.ttf) {
    $fileName = $file.Name
    if (-not(Test-Path -Path "C:\Windows\fonts\$fileName" )) {
        echo $fileName
        dir $file | % { $fonts.CopyHere($_.fullname) }
    }
}
cp ./envFonts/*.ttf c:\windows\fonts\

# Check for chocolatey and install it if it isnt.

$testchoco = powershell choco -v
if (-not($testchoco)) {
    Write-Output "Seems Chocolatey is not installed, installing now"
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}
else {
    Write-Output "Chocolatey Version $testchoco is already installed"
}
# Download and Install starship shell
choco install starship

# Add starship to powershell profile
Add-Content -Path $PROFILE -Value "Invoke-Expression (&starship init powershell)"

# Install starship config

# Ensure the destination directory exists
if (-not (Test-Path -Path "$HOME\.config")) {
    New-Item -Path "$HOME\.config" -ItemType Directory
}

# Define source and destination paths for clarity
$sourcePath = "terminal/starship/starship.toml"
$destinationPath = "$HOME\.config\starship.toml"

# Check if destination file doesn't exist or its content differs from the source
if (-not (Test-Path -Path $destinationPath) -or (Get-FileHash -Path $sourcePath).Hash -ne (Get-FileHash -Path $destinationPath).Hash) {
    Copy-Item -Path $sourcePath -Destination $destinationPath -Force
    Write-Output "File copied to $destinationPath"
} else {
    Write-Output "No changes detected. File not copied."
}

echo "Done. Don't forget to select the patched Nerd Font in Microsoft Terminal."