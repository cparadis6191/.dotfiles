#!/usr/bin/env bash

# See https://nixos.org/download/ for more information.
sh <(curl -L https://nixos.org/nix/install) --no-daemon

# Do not source `nix.fish` in fish.
sed --expression='/# added by Nix installer/d' --in-place "$HOME/.config/fish/conf.d/nix.fish"

# See https://nix-community.github.io/home-manager/#sec-install-standalone for
# more information.
mkdir --parents "$HOME/.config/nix"
echo 'experimental-features = nix-command flakes' >> "$HOME/.config/nix/nix.conf"

source "$HOME/.nix-profile/etc/profile.d/nix.sh"

nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update

nix-shell '<home-manager>' --attr install

home-manager switch -b bak --flake "$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
