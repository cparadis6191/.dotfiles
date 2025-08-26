# Source local bash_profile if it exists
if [[ -f "$HOME/.local/etc/.bash_profile" ]]; then
	source "$HOME/.local/etc/.bash_profile"
fi

# Source user bashrc if it exists
if [[ -f "$HOME/.bashrc" ]]; then
	source "$HOME/.bashrc"
fi
