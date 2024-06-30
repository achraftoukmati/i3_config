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

# Enable tapping and natural scrolling using xinput
xinput set-prop "$TOUCH_DEVICE_ID" 'libinput Tapping Enabled' 1
xinput set-prop "$TOUCH_DEVICE_ID" 'libinput Natural Scrolling Enabled' 1

echo "Touch configuration applied for device: $TOUCH_DEVICE"

