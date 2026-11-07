#!/bin/sh

DIR="$HOME/Pictures/"
mkdir -p "$DIR"
# screenshot-2026-01-03_21-33-23.png
FILE="$DIR/screenshot-$(date +%Y-%m-%d_%H-%M-%S).png"

grim "$FILE" && wl-copy <"$FILE"
