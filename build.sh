#!/usr/bin/env bash

echo "------------------------------------------------"
echo #
echo "Blog web service building script started"
echo #
echo "Setting up environment"
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if test -d "$THIS_DIR/build"; then
	echo "Emptying old blog build directory"
	rm -rf "$THIS_DIR/build"
fi
mkdir -p "$THIS_DIR/build"

echo "Setting up environment done"
echo #
echo "Rebuild global assets"

if test -d "$THIS_DIR/../global_assets"; then
        cd "$THIS_DIR/../global_assets"
        ./build.sh
        cd "$THIS_DIR"
else
        echo "Missing global assets directory at $THIS_DIR/../global_assets"
        exit 1
fi

echo #
echo "Rebuilding global assets done"
echo "- - - - - - - - - - - - - - - - - - - - - - - -"
echo #
echo "Building blog post snippets"
./build_snippets.sh
echo #
echo "Blog post snippets built"
echo "- - - - - - - - - - - - - - - - - - - - - - - -"







echo "Building blog pages"

FOOTER_FILE="$THIS_DIR/../global_assets/build/footer.html"
HEADER_FILE="$THIS_DIR/../global_assets/build/header.html"
STYLE_FILE="$THIS_DIR/../global_assets/build/style.html"
