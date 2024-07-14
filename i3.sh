#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install i3 if not installed
if ! command_exists i3; then
    echo "i3 is not installed. Installing i3..."
    if command_exists apt-get; then
        sudo apt-get update
        sudo apt-get install -y i3
    elif command_exists pacman; then
        sudo pacman -Sy i3
    elif command_exists dnf; then
        sudo dnf install -y i3
    else
        echo "Unsupported package manager. Please install i3 manually."
        exit 1
    fi
else
    echo "i3 is already installed."
fi

# Create the i3 config directory if it doesn't exist
CONFIG_DIR="$HOME/.config/i3"
if [ ! -d "$CONFIG_DIR" ]; then
    mkdir -p "$CONFIG_DIR"
    echo "Created config directory at $CONFIG_DIR"
fi

# Create a basic i3 config file
CONFIG_FILE="$CONFIG_DIR/config"
cat > "$CONFIG_FILE" <<EOL
# i3 config file

# Set mod key to Win key
set \$mod Mod4

# Use Mouse+Mod to drag floating windows to their wanted position
floating_modifier \$mod

# Font for window titles
font pango:monospace 8

# Start a terminal
bindsym \$mod+Return exec i3-sensible-terminal

# Kill focused window
bindsym \$mod+Shift+q kill

# Start dmenu (a program launcher)
bindsym \$mod+d exec dmenu_run

# Change focus
bindsym \$mod+h focus left
bindsym \$mod+j focus down
bindsym \$mod+k focus up
bindsym \$mod+l focus right

# Move focused window
bindsym \$mod+Shift+h move left
bindsym \$mod+Shift+j move down
bindsym \$mod+Shift+k move up
bindsym \$mod+Shift+l move right

# Split in horizontal orientation
bindsym \$mod+Shift+space split h

# Reload the configuration file
bindsym \$mod+Shift+c reload

# Restart i3 inplace (preserves your layout/session)
bindsym \$mod+Shift+r restart

# Exit i3
bindsym \$mod+Shift+e exit

# Start i3bar to display a workspace bar (plus the system information i3status)
bar {
    status_command i3status
}
EOL

echo "i3 configuration file created at $CONFIG_FILE"

# Prompt user to start i3
echo "To start i3, log out and select i3 from your login manager, or run 'i3' from the terminal."

