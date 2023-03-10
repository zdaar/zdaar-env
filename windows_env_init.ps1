# Make sure to install Fonts first

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
mkdir -p ~/.config
Copy-Item -Path terminal/starship/starship.toml -Destination "$HOME\.config\starship.toml" -Force
