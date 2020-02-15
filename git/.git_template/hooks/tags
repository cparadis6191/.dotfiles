#!/usr/bin/env bash

if [[ $(git rev-parse --is-inside-work-tree) != 'true' ]]; then
	exit 1
fi

set -e

git_dir=$(git rev-parse --git-dir)
top_dir=$(git rev-parse --show-toplevel)
lsof -t "$git_dir/tags.lock" | xargs --no-run-if-empty kill -SIGINT
(
	flock --timeout 5 200

	trap '{
		rm -f "$git_dir/$$.tags"

		rm -f "$git_dir/$$.cscope.out"
		rm -f "$git_dir/n$$.cscope.out"
		rm -f "$git_dir/$$.cscope.out.in"
		rm -f "$git_dir/$$.cscope.out.po"

		rm -f "$git_dir/$$.files"
		rm -f "$git_dir/$$.cscope.files"
	}' EXIT

	git ls-files > "$git_dir/$$.files"
	while read line
	do
		echo "\"$top_dir/$line\"" >> "$git_dir/$$.cscope.files"
	done < "$git_dir/$$.files"

	ctags --excmd=number --sort=foldcase --tag-relative -L "$git_dir/$$.files" -f "$git_dir/$$.tags"
	cscope -b -C -q -i "$git_dir/$$.cscope.files" -f "$git_dir/$$.cscope.out"

	mv "$git_dir/$$.tags"          "$git_dir/tags"

	mv "$git_dir/$$.cscope.out"    "$git_dir/cscope.out"
	mv "$git_dir/$$.cscope.out.in" "$git_dir/cscope.out.in"
	mv "$git_dir/$$.cscope.out.po" "$git_dir/cscope.out.po"
) 200> "$git_dir/tags.lock"
