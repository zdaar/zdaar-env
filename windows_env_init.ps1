# Check if we are admin, if not, exit
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    [System.Windows.Forms.Messagebox]::Show("This script needs to be run as administrator!")
    exit
}

# Install Fonts
echo "Installing fonts..."
$fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)
foreach ($file in Get-ChildItem ./envFonts/*.ttf) {
    $fileName = $file.Name
    if (-not(Test-Path -Path "C:\Windows\Fonts\$fileName")) {
        echo "Installing $fileName..."
        $fonts.CopyHere($file.FullName)
    }
}

# Check for chocolatey and install it if it's not installed
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Output "Chocolatey is not installed. Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
} else {
    Write-Output "Chocolatey is already installed."
}

# Check for scoop and install it if it's not installed
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Output "Scoop is not installed. Installing Scoop..."
    iex (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
} else {
    Write-Output "Scoop is already installed."
}

# Install oh-my-posh using scoop
Write-Output "Installing Oh My Posh..."
scoop install https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/oh-my-posh.json

# Add oh-my-posh to the PowerShell profile
Write-Output "Configuring Oh My Posh in PowerShell profile..."
if (-not (Test-Path -Path $PROFILE)) {
    New-Item -Path $PROFILE -ItemType File -Force
}
Add-Content -Path $PROFILE -Value "`nInvoke-Expression (&oh-my-posh init pwsh)"

# Ensure the destination directory exists for the config file
if (-not (Test-Path -Path "$HOME\.config")) {
    New-Item -Path "$HOME\.config" -ItemType Directory
}

# Define source and destination paths for clarity
$sourcePath = "terminal/starship/starship.toml"
$destinationPath = "$HOME\.config\starship.toml"

# Check if destination file doesn't exist or its content differs from the source
if (-not (Test-Path -Path $destinationPath) -or (Get-FileHash -Path $sourcePath).Hash -ne (Get-FileHash -Path $destinationPath).Hash) {
    Copy-Item -Path $sourcePath -Destination $destinationPath -Force
    Write-Output "Configuration file copied to $destinationPath"
} else {
    Write-Output "No changes detected. Configuration file not copied."
}

Write-Output "Setup complete. Don't forget to select the patched Nerd Font in your terminal!"
