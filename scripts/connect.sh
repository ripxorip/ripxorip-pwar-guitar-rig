#!/usr/bin/env bash
# Sample connect.sh for Ghost Rig

wait_for_pw_nodes() {
    local timeout=15
    local interval=1
    local elapsed=0
    local alsa_in="alsa_input.usb-Focusrite_Scarlett_6i6_USB_00003367-00.analog-surround-21"
    local alsa_out="alsa_output.usb-Focusrite_Scarlett_6i6_USB_00003367-00.analog-surround-21"
    echo "[connect.sh] Waiting for PipeWire nodes: pwar, pw-ghost-rec, $alsa_in, $alsa_out..."
    while true; do
        local nodes=$(pw-cli ls Node 2>/dev/null)
        if echo "$nodes" | grep -q 'pwar' \
           && echo "$nodes" | grep -q 'pw-ghost-rec' \
           && echo "$nodes" | grep -q "$alsa_in" \
           && echo "$nodes" | grep -q "$alsa_out"; then
            echo "[connect.sh] All required nodes found."
            break
        fi
        sleep $interval
        elapsed=$((elapsed + interval))
        if [ "$elapsed" -ge "$timeout" ]; then
            echo "[connect.sh] Timeout waiting for PipeWire nodes." >&2
            exit 1
        fi
    done
}

wait_for_pw_nodes

echo "[connect.sh] Connecting ports..."
pw-link alsa_input.usb-Focusrite_Scarlett_6i6_USB_00003367-00.analog-surround-21:capture_FR pw-ghost-rec:input
pw-link pw-ghost-rec:output-right pwar:input
pw-link pwar:output-left alsa_output.usb-Focusrite_Scarlett_6i6_USB_00003367-00.analog-surround-21:playback_FL
pw-link pwar:output-right alsa_output.usb-Focusrite_Scarlett_6i6_USB_00003367-00.analog-surround-21:playback_FR
echo "[connect.sh] Connections established."
