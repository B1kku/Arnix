#!/usr/bin/env bash
command="n"
for file in "$@"; do
    command="${command} ${file}"
done
exec nvim --server $NVIM --remote-send "<CMD>q<CR><CMD>lua vim.cmd([[$command]])<CR>"
