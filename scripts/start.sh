#!/usr/bin/env bash
set -e

trap cleanup SIGINT

cleanup() {
    echo "[Ghost Rig] Caught Ctrl+C. Killing..."
    kill -TERM -$PWAR_PGID -$REC_PGID -$MIDI_PGID 2>/dev/null
    echo "[Ghost Rig] Done."
    exit 0
}

echo "[Ghost Rig] Setting latency to 128/48000..."
export PIPEWIRE_LATENCY=128/48000

echo "[1] Starting PWAR..."
# Define color codes using $'...' for proper escape interpretation
GREEN=$'\033[0;32m'
BLUE=$'\033[0;34m'
ORANGE=$'\033[38;5;208m'
NC=$'\033[0m' # No Color

( stdbuf -oL nix run .#pwar | sed "s/^/${GREEN}[PWAR]: ${NC}/" ) &
PWAR_PID=$!
PWAR_PGID=$PWAR_PID

echo "[2] Starting pw-ghost-rec..."
( stdbuf -oL nix run .#pw-ghost-rec | sed "s/^/${BLUE}[REC]: ${NC}/" ) &
REC_PID=$!
REC_PGID=$REC_PID

echo "[3] Starting midi_udp_streamer..."
( stdbuf -oL nix run .#midi-udp-streamer | sed "s/^/${ORANGE}[MIDI]: ${NC}/" ) &
MIDI_PID=$!
MIDI_PGID=$MIDI_PID

echo "[4] Connecting ports..."
./scripts/connect.sh

echo "[Ghost Rig] Running. Ctrl+C to quit."
while true; do sleep 1; done
