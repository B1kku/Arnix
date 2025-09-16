#!/usr/bin/env bash

warn() {
  local warning="$1"
  echo "vim.notify([[$warning]], vim.log.levels.WARN);"
}

lua_code="<CMD>lua vim.api.nvim_win_hide(0);"
invalid_args=()
file_names=()
file_name_flag=false

for file in "$@"; do
  # Escape file names just in case
  escaped_file=$(printf "%q" "$file")
  
  # Anything after -- should be interpreted as a literal file name
  if [[ $escaped_file == "--" ]]; then
    file_name_flag=true
    continue 
  fi
  # If file is +digits it's a file number to navigate to when opening the file
  if [[ $escaped_file =~ ^\+[0-9]+$ && ! $file_name_flag ]]; then
    line_nr="${escaped_file:1}"
    continue 
  fi
  # Arguments or commands are not supported yet.
  if [[ ($escaped_file == -* || $escaped_file == +*)  && ! $file_name_flag ]]; then
    invalid_args+=("$escaped_file")
    continue
  fi

  file_names+=("$escaped_file")
done

# Iterate in reverse over file names found since lua will execute them left to right
for (( i=${#file_names[@]} -1 ; i>=0; i-- )); do
  file_name="${file_names[i]}"
  lua_code+="vim.cmd.edit([[$file_name]]);"
done
# Set cursor to the line if any was specified.
if [ -v line_nr ]; then
  lua_code+="vim.api.nvim_win_set_cursor(0, {$line_nr,0});"
fi

#Warn user of invalid arguments.
if [ ${#invalid_args[@]} -gt 0 ]; then
  warn="vim.notify(\"Nvim-wrapper, invalid arguments:\n"
  for (( i=${#invalid_args[@]} -1 ; i>=0; i-- )); do
    arg="${invalid_args[i]}"
    warn+="\t$arg\n"
  done
  warn+="\", vim.log.levels.WARN);"
  lua_code+=$warn
fi
lua_code+="<CR>"

exec nvim --server "$NVIM" --remote-send "$lua_code"
