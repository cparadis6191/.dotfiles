#!/usr/bin/env bash

set -e
git_dir="$(git rev-parse --git-dir)"

lsof -t "$git_dir/tags.lock" | xargs --no-run-if-empty kill -SIGINT
(
flock --timeout 5 200

function remove_temps {
	rm -f "$git_dir/$$.tags"

	rm -f "$git_dir/$$.cscope.out"
	rm -f "$git_dir/n$$.cscope.out"
	rm -f "$git_dir/$$.cscope.out.in"
	rm -f "$git_dir/$$.cscope.out.po"

	rm -f "$git_dir/$$.files"
	rm -f "$git_dir/$$.cscope.files"
}
trap 'remove_temps' EXIT

git ls-files -z | tr "\0" "\n" > "$git_dir/$$.files"
top_dir="$(git rev-parse --show-toplevel)"
awk --assign top_dir="$top_dir/" '{ print "\""top_dir$0"\"" }' "$git_dir/$$.files" > "$git_dir/$$.cscope.files"

ctags --excmd=number --sort=foldcase --tag-relative -L "$git_dir/$$.files" -f "$git_dir/$$.tags"
cscope -b -C -q -i "$git_dir/$$.cscope.files" -f "$git_dir/$$.cscope.out"

mv "$git_dir/$$.tags"          "$git_dir/tags"

mv "$git_dir/$$.cscope.out"    "$git_dir/cscope.out"
mv "$git_dir/$$.cscope.out.in" "$git_dir/cscope.out.in"
mv "$git_dir/$$.cscope.out.po" "$git_dir/cscope.out.po"
) 200> "$git_dir/tags.lock"
