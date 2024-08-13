#!/bin/bash

# Script to initialize bash configurations in .bashrc

echo "Configuring .bashrc with necessary settings..."

# Associative array of environment variables to add to .bashrc with initial placeholders
declare -A env_vars=(
    ["OPENAI_API_KEY"]=""  # Placeholder for the OpenAI API key
)

# Function to check and prompt for environment variables if not already set in .bashrc
check_and_prompt_env_var() {
    local var_name=$1
    if ! grep -q "^export $var_name=" ~/.bashrc; then
        # Variable not set, prompt for it
        read -p "Enter value for $var_name: " value
        env_vars[$var_name]=$value  # Update the associative array with the new value
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

# Inject all collected environment variable values into .bashrc
for var_name in "${!env_vars[@]}"; do
    if [ ! -z "${env_vars[$var_name]}" ]; then  # Only add to .bashrc if a value was provided
        echo "export $var_name='${env_vars[$var_name]}'" >> ~/.bashrc
    fi
done

# Apply alias settings
for name in "${!aliases[@]}"; do
    add_alias "$name" "${aliases[$name]}"
done

echo "Completed configuration of .bashrc."
source ~/.bashrc
