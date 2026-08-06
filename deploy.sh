#!/bin/bash
# Deploy openpaw-website to GitHub Pages

cd /e/openpaw-website
TOKEN=$(git credential fill <<< $'protocol=https\nhost=github.com\n' | grep password | cut -d= -f2)
REPO="openpaw-website"
USER="DhirajSharma89"

echo "=== Creating GitHub repo $REPO ==="
curl -s -H "Authorization: token $TOKEN" \
     -H "Accept: application/vnd.github.v3+json" \
     https://api.github.com/user/repos \
     -d "{\"name\":\"$REPO\",\"description\":\"OpenPaw - Open Source Pet Robot Platform\",\"private\":false,\"has_pages\":true}" \
     | grep -E '"full_name"|"html_url"' | head -2

echo "=== Initializing git ==="
rm -rf .git 2>/dev/null
git init
git checkout -b main
git config user.name "DhirajSharma89"
git config user.email "rhombahu@gmail.com"

# Create .gitattributes for large files
echo "*.glb filter=lfs diff=lfs merge=lfs -text" > .gitattributes

# Create README
echo "# OpenPaw Website" > README.md

echo "=== Adding files ==="
git add .
git status | head -20

echo "=== Committing ==="
git commit -m "Initial commit: OpenPaw website with 3D robot model viewer" 2>&1 | tail -5

echo "=== Pushing to GitHub ==="
git remote add origin https://$TOKEN@github.com/$USER/$REPO.git
git push -u origin main 2>&1 | tail -10

echo "=== Enabling GitHub Pages ==="
curl -s -H "Authorization: token $TOKEN" \
     -H "Accept: application/vnd.github.v3+json" \
     -X POST "https://api.github.com/repos/$USER/$REPO/pages" \
     -d "{\"source\":{\"branch\":\"main\",\"path\":\"/\"}}" 2>&1 | grep -E '"status"|"html_url"|"url"' | head -3

echo "=== Pages info ==="
curl -s -H "Authorization: token $TOKEN" \
     -H "Accept: application/vnd.github.v3+json" \
     "https://api.github.com/repos/$USER/$REPO/pages" \
     | grep -E '"html_url"|"status"' | head -3

echo ""
echo "DONE! Your site will be available at:"
echo "  https://$USER.github.io/$REPO/"
echo "GitHub Pages may take a few minutes to deploy."