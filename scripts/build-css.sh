#!/bin/bash

# IMPORTANT: call this script from the project root; otherwise, it won't find the files correctly.
# ex: bash scripts/build-css.sh

# convert all scss files to css using sass
scss_files=$(ls src/scss/*.scss)

for file in $scss_files; do
  base_name=$(basename $file)
  npx -y sass "$file" "assets_v2/css/${base_name%.scss}.css" --no-source-map
done
