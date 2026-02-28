#!/usr/bin/env bash

# Sub-script for `build.sh`
# Not designed to be run standalone

echo "------------------------------------------------"
echo #
echo "Blog post snippet building script started"
echo #
echo "Checking environment"
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILD_DIR="$THIS_DIR/build"
# This script assumes that the blog build directory has been handled already
if ! test -d "$BUILD_DIR"; then
        echo "Missing blog build directory at $BUILD_DIR"
        exit 1
fi

SNIPPETS_BUILD_DIR="$BUILD_DIR/snippets"
if test -d "$SNIPPETS_BUILD_DIR"; then
    rm -rf "$SNIPPETS_BUILD_DIR"
fi
mkdir -p "$SNIPPETS_BUILD_DIR"

TEMPLATE_SNIPPET="$THIS_DIR/../global_assets/templates/blog_snippet.html"
if ! test -f "$TEMPLATE_SNIPPET"; then
    echo "Missing template snippet at $TEMPLATE_SNIPPET"
    exit 1
fi

echo "Checking environment done"
echo "- - - - - - - - - - - - - - - - - - - - - - - -"
echo #
echo "Building blog post snippets"

# Loop through each post directory
for post_dir in "$THIS_DIR/pages/posts/"*; do
    if [ -d "$post_dir" ]; then
        post_name=$(basename "$post_dir")
        # Skip the template directory
        if [ "$post_name" == "template_dir" ]; then
            continue
        fi

        post_file="$post_dir/post.md"
        if [ -f "$post_file" ]; then
            echo "Processing snippet for: $post_name"
            # Use pandoc to create the snippet from the front-matter of the post
            # We use an empty body because we only want the template metadata
            pandoc "$post_file" \
                --template="$TEMPLATE_SNIPPET" \
                -t html \
                -o "$SNIPPETS_BUILD_DIR/$post_name.snippet.html"
        fi
    fi
done

echo #
echo "Blog post snippet building script finished"
echo "------------------------------------------------"
