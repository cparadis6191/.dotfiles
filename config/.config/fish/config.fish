if status is-interactive
    # Commands to run in interactive sessions can go here

    # Source local config.fish if it exists
    if test -f ~/.local/etc/.config/fish/config.fish
        source ~/.local/etc/.config/fish/config.fish
    end
end
