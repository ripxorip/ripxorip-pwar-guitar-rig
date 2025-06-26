#!/usr/bin/env bash
# Sample connect.sh for Ghost Rig

echo "[connect.sh] Connecting ports..."
echo "[connect.sh] Waiting for the PipeWire nodes to settle..."
sleep 2
pw-link alsa_input.usb-Focusrite_Scarlett_6i6_USB_00003367-00.analog-surround-21:capture_FR pw-ghost-rec:input
pw-link pw-ghost-rec:output-right pwar:input
pw-link pwar:output-left alsa_output.usb-Focusrite_Scarlett_6i6_USB_00003367-00.analog-surround-21:playback_FL
pw-link pwar:output-right alsa_output.usb-Focusrite_Scarlett_6i6_USB_00003367-00.analog-surround-21:playback_FR
