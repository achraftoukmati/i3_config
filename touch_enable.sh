#!/bin/bash

# Get the list of input devices and find the touch device ID
TOUCH_DEVICE=$(xinput list --name-only | grep -iE 'touch|touchpad')

if [ -z "$TOUCH_DEVICE" ]; then
  echo "No touch device found."
  exit 1
fi

TOUCH_DEVICE_ID=$(xinput list | grep -i "$TOUCH_DEVICE" | grep -o 'id=[0-9]*' | grep -o '[0-9]*')

if [ -z "$TOUCH_DEVICE_ID" ]; then
  echo "Failed to get the touch device ID."
  exit 1
fi

# Check the driver used by the device
DRIVER_INFO=$(xinput --list-props "$TOUCH_DEVICE_ID" | grep "Device Node")

# Function to configure libinput
configure_libinput() {
  echo "Configuring libinput for touch device: $TOUCH_DEVICE"

  # Create the configuration file for libinput
  sudo mkdir -p /etc/X11/xorg.conf.d
  sudo tee /etc/X11/xorg.conf.d/40-libinput.conf > /dev/null <<EOL
Section "InputClass"
    Identifier "libinput touchpad catchall"
    MatchIsTouchpad "on"
    MatchProduct "$TOUCH_DEVICE"
    Driver "libinput"
    Option "Tapping" "on"
    Option "ClickMethod" "clickfinger"
    Option "TappingButtonMap" "lrm"
EndSection
EOL

  echo "Configuration for libinput applied. Please restart your X session."
}

# Function to configure Synaptics
configure_synaptics() {
  echo "Configuring Synaptics driver for touch device: $TOUCH_DEVICE"

  # Create or update ~/.xprofile to make synclient settings persistent
  echo "synclient TapButton1=1" >> ~/.xprofile
  echo "synclient TapButton2=3" >> ~/.xprofile
  echo "synclient TapButton3=2" >> ~/.xprofile

  # Apply settings immediately
  synclient TapButton1=1
  synclient TapButton2=3
  synclient TapButton3=2

  echo "Configuration for Synaptics applied. Settings will persist on next login."
}

# Function to configure fallback
configure_fallback() {
  echo "Configuring fallback method for touch device: $TOUCH_DEVICE"

  # Create or update ~/.xprofile to enable tapping using xinput
  echo "xinput set-prop '$TOUCH_DEVICE' 'libinput Tapping Enabled' 1" >> ~/.xprofile
  echo "xinput set-prop '$TOUCH_DEVICE' 'libinput Natural Scrolling Enabled' 1" >> ~/.xprofile

  # Apply settings immediately
  xinput set-prop "$TOUCH_DEVICE_ID" 'libinput Tapping Enabled' 1
  xinput set-prop "$TOUCH_DEVICE_ID" 'libinput Natural Scrolling Enabled' 1

  echo "Fallback configuration applied. Settings will persist on next login."
}

if [[ "$DRIVER_INFO" == *"libinput"* ]]; then
  configure_libinput
elif synclient -l &> /dev/null; then
  configure_synaptics
else
  configure_fallback
fi

# Reload i3 configuration
i3-msg reload

