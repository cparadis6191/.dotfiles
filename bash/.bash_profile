# Source local bash_profile if it exists
if [[ -f "$HOME/.bash_profile.local" ]]; then
	source "$HOME/.bash_profile.local"
fi

# Source user bashrc if it exists
if [[ -f "$HOME/.bashrc" ]]; then
	source "$HOME/.bashrc"
fi
