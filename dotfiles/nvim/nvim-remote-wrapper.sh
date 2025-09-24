#!/usr/bin/env bash
# If neovim takes longer than this to kill us
# something probably went wrong, exit anyways.
TIMEOUT=$(( 15 * 60 ))
sleep_pid=""
# Lua strings work different than bash, most proper way I found to translate them
# is to use [=[]=] string literals in lua, since '=' can be of variable length to avoid
# edge cases where a command or file could close the string literal, we'll find all patterns
# matching a closing string literal ](=+)] and use 1 more '=' than the largest pattern.
# Example: "example]===]string]====]" would convert to [=====[example]===]string]====]]=====]
string_to_lua() {
  escape_string=$1
  padding_n=1
  possible_escapes=("$(echo "$escape_string" | grep -o '\]=\+\]')")
  for unsafe_characters in "${possible_escapes[@]}"; do
    unsafe_padding_n=$((${#unsafe_characters} - 2))
    if [[ $unsafe_padding_n -gt $padding_n ]]; then
      padding_n=$unsafe_padding_n
    fi
  done

  padding_n=$((padding_n + 1))

  padding=$(printf -- "%0.s=" $(seq 1 $padding_n))
  escape_start="[$padding"[
  escape_end="]$padding]"
  lua_string="$escape_start$escape_string$escape_end"
  echo "$lua_string"
}

on_exit() {
  exec nvim --server "$NVIM" --remote-send "<CMD>lua I([[Killing script $sleep_pid, bye bye.]])<CR>"
  exit 0
}

# Reroute all args + pid to neovim.
for arg in "$@"; do
  # echo "$arg"
  arg="$(printf %q "$arg")"
  lua_code+="$(string_to_lua "$arg"),"
done

# Make a sleep process and pass it's pid to neovim.
# We'll wait for neovim to kill it or the timeout to end.
sleep "$TIMEOUT" &
sleep_pid=$!

lua_code="<CMD>lua require([[modules.remote-wrapper]]).receive($sleep_pid,{$lua_code})<CR>"

nvim --server "$NVIM" --remote-send "$lua_code"
# # Wait for trap or timeout
wait $sleep_pid
on_exit
