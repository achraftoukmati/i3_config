#!/usr/bin/env bash

# Function to check if a command exists
cmd_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to print formatted messages
echof() {
    local type="$1"
    local message="$2"
    case "$type" in
        error) echo -e "\e[31m[ERROR]\e[0m $message" ;;
        info) echo -e "\e[34m[INFO]\e[0m $message" ;;
        act) echo -e "\e[32m[ACTION]\e[0m $message" ;;
        *) echo "$message" ;;
    esac
}

# Set the path to i3lock-color binary
i3lockcolor_bin=$(which i3lock-color)

if ! cmd_exists "$i3lockcolor_bin"; then
    echof error "Unable to find i3lock-color binary under detected/configured name: '$i3lockcolor_bin'!"
    exit 1
fi

# Lock the screen with a simple configuration
$i3lockcolor_bin -c 000000  # Locks the screen with a black background

echof info "Screen locked with i3lock-color."