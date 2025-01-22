#!/usr/bin/env bash

# See https://nixos.org/download/ for more information.
sh <(curl -L https://nixos.org/nix/install) --no-daemon

# See https://nix-community.github.io/home-manager/#sec-install-standalone for
# more information.
echo 'experimental-features = nix-command flakes' > "$HOME/.config/nix/nix.conf"

nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

nix-shell '<home-manager>' --attr install

home-manager switch --flake "$HOME/.dotfiles"
