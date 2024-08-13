#!/bin/bash

# Define the path to the .bashrc file
TARGET_FILE="$HOME/.bashrc"

# Declare an associative array where each key is the alias name, and the value is the command
declare -A aliases
aliases[fuck]="sudo \$(fc -nl -1)"
aliases[ll]="ls -lah"
aliases[gs]="git status"

# Function to add alias if it does not exist in the .bashrc
add_alias_if_not_exists() {
    local alias_name=$1
    local alias_command=$2

    # Prepare the full alias string
    local full_alias="alias ${alias_name}='${alias_command}'"

    # Check if the alias is already defined
    if grep -q "^alias ${alias_name}=" "$TARGET_FILE"; then
        echo "Alias '${alias_name}' already exists in ${TARGET_FILE}."
    else
        # Append the alias if not found
        echo "$full_alias" >> "$TARGET_FILE"
        echo "Alias '${alias_name}' added to ${TARGET_FILE}."
    fi
}

# Iterate over the associative array and check each alias
for alias_name in "${!aliases[@]}"; do
    add_alias_if_not_exists "$alias_name" "${aliases[$alias_name]}"
done

# Optionally reload .bashrc to make aliases available immediately
# This is commented out because you may not want to source .bashrc in non-interactive scripts
# source "$TARGET_FILE"
echo "Alias check and addition complete."
