#!/usr/bin/env bash

set -e
dir="$(git rev-parse --git-dir)"

lsof -t "$dir/tags.lock" | xargs --no-run-if-empty kill -SIGINT
(
flock --timeout 5 200

function remove_temps {
	rm -f "$dir/$$.tags"

	rm -f "$dir/$$.cscope.out"
	rm -f "$dir/n$$.cscope.out"
	rm -f "$dir/$$.cscope.out.in"
	rm -f "$dir/$$.cscope.out.po"

	rm -f "$dir/$$.files"
	rm -f "$dir/$$.cscope.files"
}
trap 'remove_temps' EXIT

git ls-files -z | tr "\0" "\n" > "$dir/$$.files"
top="$(git rev-parse --show-toplevel)"
awk --assign top="$top/" '{ print "\""top$0"\"" }' "$dir/$$.files" > "$dir/$$.cscope.files"

ctags --excmd=number --sort=foldcase --tag-relative -L "$dir/$$.files" -f "$dir/$$.tags"
cscope -b -C -q -i "$dir/$$.cscope.files" -f "$dir/$$.cscope.out"

mv "$dir/$$.tags"          "$dir/tags"

mv "$dir/$$.cscope.out"    "$dir/cscope.out"
mv "$dir/$$.cscope.out.in" "$dir/cscope.out.in"
mv "$dir/$$.cscope.out.po" "$dir/cscope.out.po"
) 200> "$dir/tags.lock"
