#!/bin/bash
cd /e/openpaw-website

# Get the token
TOKEN=$(echo -e "protocol=https\nhost=github.com\n" | git credential fill 2>/dev/null | grep password | cut -d= -f2)

git add -A
git commit -m "Update site" 2>&1 | tail -2
git push -f origin main 2>&1 | tail -10

echo "---"
echo "Done! Site: https://dhirajsharma89.github.io/openpaw-website/"