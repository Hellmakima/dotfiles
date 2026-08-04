#!/bin/sh
set -e

stow -t "$HOME" home
sudo stow -t /etc etc
