#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to add or update a line in .bashrc
add_or_update_bashrc() {
    local search="$1"
    local replace="$2"
    if grep -q "$search" ~/.bashrc; then
        sed -i "s|$search.*|$replace|" ~/.bashrc
    else
        echo "$replace" >> ~/.bashrc
    fi
}

# Function to safely replace or add ls aliases
safely_replace_or_add_ls_alias() {
    local alias_name="$1"
    local exa_command="$2"
    
    if grep -qE "^(#[[:space:]]*)?(alias[[:space:]]+)?${alias_name}=" ~/.bashrc; then
        sed -i "/^#*[[:space:]]*alias[[:space:]]*${alias_name}=/c\alias ${alias_name}=\"${exa_command}\"" ~/.bashrc
        echo "Updated existing alias $alias_name"
    else
        echo "alias ${alias_name}=\"${exa_command}\"" >> ~/.bashrc
        echo "Added new alias $alias_name"
    fi
}

# Install and configure xclip
if ! command_exists xclip; then
    echo "Installing xclip..."
    sudo apt-get update && sudo apt-get install -y xclip
else
    echo "xclip is already installed."
fi
add_or_update_bashrc "alias xclip=" "alias xclip=\"xclip -selection c\""

# Install and configure hstr
if ! command_exists hstr; then
    echo "Installing hstr..."
    sudo add-apt-repository -y ppa:ultradvorka/ppa
    sudo apt-get update && sudo apt-get install -y hstr
else
    echo "hstr is already installed."
fi
add_or_update_bashrc "export HSTR_CONFIG=" "export HSTR_CONFIG=hicolor,raw-history-view"
add_or_update_bashrc "export HSTR_PROMPT=" "export HSTR_PROMPT=\"$ \""
#add_or_update_bashrc "bind.*hstr" "if [[ \$- =~ .*i.* ]]; then bind '\"\\C-r\": \"\\C-a hstr -- \\C-j\"'; fi"
add_or_update_bashrc "export HSTR_TIOCSTI=" "export HSTR_TIOCSTI=y"
add_or_update_bashrc "alias hh=" "alias hh=\"hstr\""

# Install ncdu
if ! command_exists ncdu; then
    echo "Installing ncdu..."
    sudo apt-get update && sudo apt-get install -y ncdu
else
    echo "ncdu is already installed."
fi

# Install and configure ripgrep
if ! command_exists rg; then
    echo "Installing ripgrep..."
    sudo apt-get update && sudo apt-get install -y ripgrep
else
    echo "ripgrep is already installed."
fi
add_or_update_bashrc "export RIPGREP_CONFIG_PATH=" "export RIPGREP_CONFIG_PATH=\"\$HOME/.ripgreprc\""
echo "--max-columns=150
--max-columns-preview
--smart-case" > ~/.ripgreprc

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

# Install and configure bat
if ! command_exists bat && ! command_exists batcat; then
    echo "Installing bat..."
    sudo apt-get update && sudo apt-get install -y bat
else
    echo "bat is already installed."
fi

# Check if the command is 'bat' or 'batcat'
if command_exists batcat; then
    BAT_CMD="batcat"
elif command_exists bat; then
    BAT_CMD="bat"
else
    echo "Error: Neither 'bat' nor 'batcat' command found after installation."
    exit 1
fi

# Set up aliases for bat
add_or_update_bashrc "alias cat=" "alias cat=\"$BAT_CMD --paging=never\""
add_or_update_bashrc "alias batcat=" "alias batcat=\"$BAT_CMD\""

# Install and configure exa
if ! command_exists exa; then
    echo "Installing exa..."
    sudo apt-get update && sudo apt-get install -y exa
else
    echo "exa is already installed."
fi

# Replace or add common ls aliases with exa equivalents
safely_replace_or_add_ls_alias "ls" "exa"
safely_replace_or_add_ls_alias "l" "exa -lbF"
safely_replace_or_add_ls_alias "ll" "exa -lbF --group-directories-first"
safely_replace_or_add_ls_alias "llm" "exa -lbGd --sort=modified"
safely_replace_or_add_ls_alias "la" "exa -lbhHigUmuSa --time-style=long-iso --git --color-scale"
safely_replace_or_add_ls_alias "lx" "exa -lbhHigUmuSa@ --time-style=long-iso --git --color-scale"
safely_replace_or_add_ls_alias "lS" "exa -1"
safely_replace_or_add_ls_alias "lt" "exa --tree --level=2"

echo "Tool installation and configuration complete."
echo "Please run 'source ~/.bashrc' to apply the changes to your current session."
