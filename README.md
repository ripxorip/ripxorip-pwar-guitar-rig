# 🎸🎤🎶 Linux Guitar Recording Rig

Welcome to my personal Linux recording setup! This flake orchestrates and ties together several custom utilities for a robust, low-latency, and flexible music production environment using PipeWire.

## Components

- **PWAR (PipeWire ASIO Relay)** 🎸
  - A PipeWire <-> UDP streaming bridge for ultra-low-latency audio, acting as an ASIO relay for seamless DAW integration.
- **pw-ghost-rec** 👻
  - A PipeWire recorder that can repair missed audio buffers, ensuring reliable and gapless audio capture.
- **midi_udp_streamer** 🎹
  - Streams MIDI events over your LAN, perfect for remote pedalboards or MIDI controllers.

## Purpose

This flake is designed to:
- Orchestrate and launch all the above tools together
- Provide a reproducible, hackable, and personal Linux guitar/music recording environment
- Make it easy to connect, record, and control your rig with PipeWire, MIDI, and custom utilities

## Usage

```sh
nix run
```

This will:
- Start PWAR, pw-ghost-rec, and midi_udp_streamer
- Connect all the right ports for audio and MIDI (see `scripts/connect.sh`)
- Set up your system for recording, jamming, or experimenting

## Requirements
- Linux (PipeWire-based audio stack)
- Nix with flakes enabled
- Your favorite guitar, pedals, and inspiration! 🎸🎤🎶

---

This is my personal setup—feel free to fork, adapt, and rock out! 🤘