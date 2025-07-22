#!/bin/bash
# syntax_check_all.sh
# Recursively check all .sh files for syntax errors and print a summary

error_count=0
file_count=0

find . -name '*.sh' | while read -r file; do
  ((file_count++))
  if bash -n "$file" 2> >(tee /tmp/syntax_error.log >&2); then
    echo "[OK]   $file"
  else
    echo "[ERROR] $file"
    cat /tmp/syntax_error.log
    ((error_count++))
  fi
done

if (( error_count == 0 )); then
  echo -e "\nAll $file_count shell scripts passed syntax check!"
else
  echo -e "\n$file_count shell scripts checked. $error_count file(s) have syntax errors."
fi 