#!/usr/bin/env bash
set -e

echo "------------------------------------------------"
echo #
echo "Deploying blog web service script started"
echo #

echo "Setting up environment..."
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$THIS_DIR"

if ! test -d "$THIS_DIR/html"; then
        mkdir -p "$THIS_DIR/html"
fi

# Deploy assumes that any building has already been done
BUILD_DIR="$THIS_DIR/build"
DATA_DIR="$THIS_DIR/data"
if ! test -d "$DATA_DIR"; then
        mkdir -p "$DATA_DIR"
fi

DEPLOYMENT_DIR="$DATA_DIR/$(date +%Y-%m-%d-%H-%M-%S)"
mkdir -p "$DEPLOYMENT_DIR"
echo "Setting up environment done."
echo "- - - - - - - - - - - - - - - - - - - - - - - -"
echo #

echo "Deploying blog pages..."
# 1. move build data to data directory
echo "Moving build data to data directory..."
mv "$BUILD_DIR/landing.html" "$DEPLOYMENT_DIR/index.html"
mv "$BUILD_DIR/posts" "$DEPLOYMENT_DIR/posts"
mv "$BUILD_DIR/ContentsTable" "$DEPLOYMENT_DIR/ContentsTable"
cp "$BUILD_DIR/favicon.png" "$DEPLOYMENT_DIR/favicon.png"
cp "$BUILD_DIR/logo.png" "$DEPLOYMENT_DIR/logo.png"
echo "Moving done."
echo #

echo "Updating favicon and logo..."
# Using absolute paths within the container for symlinks
cd "$THIS_DIR/html"
rm -f "index.html" "favicon.png" "logo.png"
ln -s -f "/usr/share/nginx/data/$(basename "$DEPLOYMENT_DIR")/index.html" "index.html"
ln -s -f "/usr/share/nginx/data/$(basename "$DEPLOYMENT_DIR")/favicon.png" "favicon.png"
ln -s -f "/usr/share/nginx/data/$(basename "$DEPLOYMENT_DIR")/logo.png" "logo.png"

# Symlink the posts directory
rm -f "posts"
ln -s -f "/usr/share/nginx/data/$(basename "$DEPLOYMENT_DIR")/posts" "posts"

# Symlink the ContentsTable directory
rm -f "ContentsTable"
ln -s -f "/usr/share/nginx/data/$(basename "$DEPLOYMENT_DIR")/ContentsTable" "ContentsTable"
echo "Symlinks created."
echo #

echo "Deploying blog pages done."
echo "- - - - - - - - - - - - - - - - - - - - - - - -"
echo #

echo "Deploying blog web service script finished"
echo "------------------------------------------------"
exit 0
