#!/bin/bash
cd /e/openpaw-website

# Get token from git credential helper
TOKEN=$(git credential fill <<< $'protocol=https\nhost=github.com\n' | grep password | cut -d= -f2)

echo "=== Pushing to GitHub ==="
git init 2>/dev/null
git checkout -b main 2>/dev/null
git config user.name "DhirajSharma89"
git config user.email "rhombahu@gmail.com"
git add index.html images/
git commit -m "Deploy OpenPaw website with 3D robot model" 2>&1 | tail -5

git remote remove origin 2>/dev/null
git remote add origin "https://${TOKEN}@github.com/DhirajSharma89/openpaw-website.git"
git push -u origin main 2>&1 | tail -15

echo "=== Enabling GitHub Pages ==="
curl -s -H "Authorization: token ${TOKEN}" \
     -H "Accept: application/vnd.github.v3+json" \
     "https://api.github.com/repos/DhirajSharma89/openpaw-website/pages" > /dev/null 2>&1

curl -s -H "Authorization: token ${TOKEN}" \
     -H "Accept: application/vnd.github.v3+json" \
     -X POST "https://api.github.com/repos/DhirajSharma89/openpaw-website/pages" \
     -d '{"source":{"branch":"main","path":"/"}}' > /dev/null 2>&1

echo "=== Getting Pages URL ==="
curl -s -H "Authorization: token ${TOKEN}" \
     -H "Accept: application/vnd.github.v3+json" \
     "https://api.github.com/repos/DhirajSharma89/openpaw-website/pages" \
     | grep '"html_url"' | head -1

echo ""
echo "Deployment pushed! GitHub Pages will build and deploy shortly."
echo "Your site will be at: https://dhirajsharma89.github.io/openpaw-website/"