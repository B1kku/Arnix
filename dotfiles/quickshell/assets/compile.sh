#!/usr/bin/env bash

DEST_FOLDER="qml_svg"

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
cd "$SCRIPT_DIR" || return
readarray -d '' files < <(find . -name "*.svg" -print0)
for filepath in "${files[@]}"; do
  # Extract the filename from the path
  filename="${filepath##*/}"
  
  # Remove the .txt extension
  name_without_ext="${filename%.svg}"
  
  # Capitalize the filename (all uppercase)
  capitalized_name="./$DEST_FOLDER/SVG_${name_without_ext^}.qml"
  
  svgtoqml --optimize-paths --curve-renderer "$filepath" "$capitalized_name"
done

# svgtoqml 
