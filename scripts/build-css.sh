#!/bin/bash

# convert all scss files to css using sass
scss_files=$(ls src/scss/*.scss)

for file in $scss_files; do
  sass $file assets_v2/css/${file%.scss}.css
done