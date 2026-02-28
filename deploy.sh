#!/usr/bin/env bash

echo "------------------------------------------------"
echo #
echo "Deploying blog web service script started"
echo #

echo "Setting up environment..."
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$THIS_DIR"

if ! test -d "$THIS_DIR/html"; then
        sudo mkdir -p "$THIS_DIR/html"
fi

# Deploy assumes that any building has already been done
BUILD_DIR="$THIS_DIR/build"
DATA_DIR="$THIS_DIR/data"
if ! test -d "$DATA_DIR"; then
        sudo mkdir -p "$DATA_DIR"
fi

DEPLOYMENT_DIR="$DATA_DIR/$(date +%Y-%m-%d-%H-%M-%S)"
sudo mkdir -p "$DEPLOYMENT_DIR"
echo "Setting up environment done."
echo "- - - - - - - - - - - - - - - - - - - - - - - -"
echo #

echo "Deploying blog pages..."
# 1. move build data to data directory
echo "Moving build data to data directory..."
sudo mv "$BUILD_DIR/landing.html" "$DEPLOYMENT_DIR/index.html"
sudo mv "$BUILD_DIR/posts" "$DEPLOYMENT_DIR/posts"
sudo mv "$BUILD_DIR/ContentsTable" "$DEPLOYMENT_DIR/ContentsTable"
echo "Moving done."
echo #

echo "Updating favicon and logo..."
sudo cp "$BUILD_DIR/favicon.png" "$THIS_DIR/html/favicon.png"
sudo cp "$BUILD_DIR/logo.png" "$THIS_DIR/html/logo.png"
echo "Updating favicon and logo done."
echo #

echo "Creating symlinks..."
cd "$THIS_DIR/html"
sudo ln -s -f "../data/$(basename "$DEPLOYMENT_DIR")/index.html" "index.html"

# Symlink the posts directory
sudo rm -f "posts"
sudo ln -s -f "../data/$(basename "$DEPLOYMENT_DIR")/posts" "posts"

# Symlink the ContentsTable directory
sudo rm -f "ContentsTable"
sudo ln -s -f "../data/$(basename "$DEPLOYMENT_DIR")/ContentsTable" "ContentsTable"
echo "Symlinks created."
echo #

echo "Deploying blog pages done."
echo "- - - - - - - - - - - - - - - - - - - - - - - -"
echo #

echo "Deploying blog web service script finished"
echo "------------------------------------------------"
exit 0
