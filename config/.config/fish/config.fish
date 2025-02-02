if status is-interactive
    # Commands to run in interactive sessions can go here

	# Change directory to bookmark
	function cdb
		cd -- (cdb-impl $argv) || return 1
	end

    # bat
    if command -v batcat > /dev/null 2>&1
        function bat
            batcat $argv
        end
    end
    if command -v bat > /dev/null 2>&1
        function cat
            bat --paging never $argv
        end
    end

    # cp
    function cp
        command cp --interactive $argv
    end

    # grep
    function grep
        command grep --color=auto $argv
    end

    # ls
    if command -v exa > /dev/null 2>&1
        function ls
            exa --color=auto $argv
        end
    else
        function ls
            command ls --color=auto $argv
        end
    end

    # mkdir
    function mkdir
        command mkdir --parents --verbose $argv
    end

    # mv
    function mv
        command mv --interactive $argv
    end

    # rm
    function rm
        command rm --interactive=once $argv
    end

    # Source local config.fish if it exists
    if test -f ~/.local/etc/.config/fish/config.fish
        source ~/.local/etc/.config/fish/config.fish
    end
end
