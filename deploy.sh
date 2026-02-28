#!/usr/bin/env bash

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
echo "Moving done."
echo #

echo "Updating favicon and logo..."
cp "$BUILD_DIR/favicon.png" "$THIS_DIR/html/favicon.png"
cp "$BUILD_DIR/logo.png" "$THIS_DIR/html/logo.png"
echo "Updating favicon and logo done."
echo #

echo "Creating symlinks..."
cd "$THIS_DIR/html"
ln -s -f "../data/$(basename "$DEPLOYMENT_DIR")/index.html" "index.html"

# Symlink the posts directory
rm -f "posts"
ln -s -f "../data/$(basename "$DEPLOYMENT_DIR")/posts" "posts"

# Symlink the ContentsTable directory
rm -f "ContentsTable"
ln -s -f "../data/$(basename "$DEPLOYMENT_DIR")/ContentsTable" "ContentsTable"
echo "Symlinks created."
echo #

echo "Deploying blog pages done."
echo "- - - - - - - - - - - - - - - - - - - - - - - -"
echo #

echo "Deploying blog web service script finished"
echo "------------------------------------------------"
exit 0
