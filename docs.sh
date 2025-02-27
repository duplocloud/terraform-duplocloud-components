#!/usr/bin/env bash

# for each of the module in the modules directory using bash globs
for module in modules/*; do
  # if the module is a directory
  if [ -d "$module" ]; then
    echo "Generating documentation for $module"
    terraform-docs "${module}"
  fi
done

