#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to add a line to .bashrc if it doesn't exist
add_to_bashrc() {
    grep -qxF "$1" ~/.bashrc || echo "$1" >> ~/.bashrc
}

# Function to add an alias to .bashrc if it doesn't exist
add_alias_to_bashrc() {
    if ! grep -q "alias $1=" ~/.bashrc; then
        echo "alias $1=\"$2\"" >> ~/.bashrc
        echo "Added alias: $1"
    else
        echo "Alias $1 already exists in .bashrc. Skipping."
    fi
}

# Install xclip
if ! command_exists xclip; then
    echo "Installing xclip..."
    sudo apt-get update && sudo apt-get install -y xclip
else
    echo "xclip is already installed."
fi

# Add xclip alias to .bashrc
add_alias_to_bashrc 'xclip' 'xclip -selection c'

# Install hstr (hh)
if ! command_exists hstr; then
    echo "Installing hstr..."
    sudo add-apt-repository -y ppa:ultradvorka/ppa
    sudo apt-get update && sudo apt-get install -y hstr
else
    echo "hstr is already installed."
fi

# Add hstr alias and configuration to .bashrc
add_alias_to_bashrc 'hh' 'hstr'
add_to_bashrc 'export HSTR_CONFIG=hicolor'
add_to_bashrc '[ -n "$BASH" ] && source "$( which hstr )"'

# Install ncdu
if ! command_exists ncdu; then
    echo "Installing ncdu..."
    sudo apt-get update && sudo apt-get install -y ncdu
else
    echo "ncdu is already installed."
fi

# Install ripgrep
if ! command_exists rg; then
    echo "Installing ripgrep..."
    sudo apt-get update && sudo apt-get install -y ripgrep
else
    echo "ripgrep is already installed."
fi

# Install htop
if ! command_exists htop; then
    echo "Installing htop..."
    sudo apt-get update && sudo apt-get install -y htop
else
    echo "htop is already installed."
fi

# Install fzf
if ! command_exists fzf; then
    echo "Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
else
    echo "fzf is already installed."
fi

# Install tldr
if ! command_exists tldr; then
    echo "Installing tldr..."
    sudo apt-get update && sudo apt-get install -y tldr
else
    echo "tldr is already installed."
fi

# Install bat
if ! command_exists bat; then
    echo "Installing bat..."
    sudo apt-get update && sudo apt-get install -y bat
else
    echo "bat is already installed."
fi

# Add bat aliases to .bashrc (without replacing cat)
add_alias_to_bashrc 'batcat' 'bat'
add_alias_to_bashrc 'bcat' 'bat --paging=never'

# Install exa
if ! command_exists exa; then
    echo "Installing exa..."
    sudo apt-get update && sudo apt-get install -y exa
else
    echo "exa is already installed."
fi

# Add exa aliases to .bashrc (without replacing ls)
add_alias_to_bashrc 'exa' 'exa'
add_alias_to_bashrc 'exal' 'exa -l'
add_alias_to_bashrc 'exaa' 'exa -la'

echo "Tool installation and configuration complete."
echo "Please run 'source ~/.bashrc' to apply the changes to your current session."