#!/bin/bash

# Script to initialize bash configurations in .bashrc

echo "Configuring .bashrc with necessary settings..."

# Associative array of environment variables to check in .bashrc
declare -A env_vars=(
    ["OPENAI_API_KEY"]=""  # Placeholder for the OpenAI API key
    # Add more environment variables here as needed
)

# Function to check and prompt for environment variables if not already set in .bashrc
check_and_prompt_env_var() {
    local var_name=$1
    if ! grep -q "^export $var_name=" ~/.bashrc; then
        # Variable not set in .bashrc, prompt for it
        echo -n "Enter value for $var_name (leave blank to skip): "
        read value
        if [ ! -z "$value" ]; then
            echo "export $var_name='$value'" >> ~/.bashrc
            echo "Added $var_name to .bashrc"
        else
            echo "Skipped adding $var_name (no value provided)"
        fi
    else
        echo "Environment variable $var_name is already set in .bashrc."
    fi
}

# Associative array of aliases to add to .bashrc
declare -A aliases=(
    ["fuck"]="sudo \$(fc -nl -1)"
    ["ll"]="ls -lah"
    ["gs"]="git status"
)

# Function to add aliases to .bashrc if not already present
add_alias() {
    local name=$1
    local command=$2
    if ! grep -q "^alias $name=" ~/.bashrc; then
        echo "Adding alias for $name..."
        echo "alias $name='$command'" >> ~/.bashrc
    else
        echo "Alias $name is already defined."
    fi
}

# Check and prompt for environment variables
for var_name in "${!env_vars[@]}"; do
    check_and_prompt_env_var "$var_name"
done

# Apply alias settings
for name in "${!aliases[@]}"; do
    add_alias "$name" "${aliases[$name]}"
done

echo "Completed configuration of .bashrc."
echo "To apply changes, please run 'source ~/.bashrc' or start a new terminal session."
