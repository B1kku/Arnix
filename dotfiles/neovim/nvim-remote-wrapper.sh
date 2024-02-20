#!/usr/bin/env bash
command="n ${*}"

exec nvim --server $NVIM --remote-send "<CMD>q<CR><CMD>lua vim.cmd([[$command]])<CR>"
