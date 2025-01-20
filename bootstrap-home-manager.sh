#!/usr/bin/env sh

# See https://nix-community.github.io/home-manager/#sec-install-standalone for
# more information.
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

nix-shell '<home-manager>' --attr install

home-manager switch --flake "$HOME/.dotfiles"
