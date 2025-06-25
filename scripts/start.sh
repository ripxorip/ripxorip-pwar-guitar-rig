#!/usr/bin/env bash
set -e

trap cleanup SIGINT

cleanup() {
    echo "[Ghost Rig] Caught Ctrl+C. Killing..."
    kill $PWAR_PID $REC_PID
    echo "[Ghost Rig] Done."
    exit 0
}

echo "[Ghost Rig] Setting latency to 128/48000..."
export PIPEWIRE_LATENCY=128/48000

echo "[1] Starting PWAR..."
(nix run .#pwar | sed 's/^/[PWAR]: /' &)
PWAR_PID=$!

echo "[2] Starting pw-ghost-rec..."
(nix run .#pw-ghost-rec | sed 's/^/[REC]: /' &)
REC_PID=$!

sleep 2

echo "[3] Connecting ports..."
./scripts/connect.sh

echo "[Ghost Rig] Running. Ctrl+C to quit."
while true; do sleep 1; done
