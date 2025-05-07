#!/usr/bin/env bash

escaped_files=""
for file in "$@"
do
    escaped_file=$(printf "%q" "$file")
    escaped_files="$escaped_files $escaped_file"
done
exec nvim --server $NVIM --remote-send "<CMD>q<CR><CMD>lua vim.cmd([[n $escaped_files]])<CR>"

