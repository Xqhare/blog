#!/usr/bin/env bash
set -e

echo "------------------------------------------------"
echo #
echo "Blog web service building script started"
echo #

echo "Setting up environment..."
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if test -d "$THIS_DIR/build"; then
        echo "Emptying old blog build directory..."
        rm -rf "$THIS_DIR/build"
fi
mkdir -p "$THIS_DIR/build"
mkdir -p "$THIS_DIR/build/posts"
mkdir -p "$THIS_DIR/build/ContentsTable"
echo "Setting up environment done."
echo "- - - - - - - - - - - - - - - - - - - - - - - -"
echo #

echo "Rebuilding global assets..."
if test -d "$THIS_DIR/../global_assets"; then
        cd "$THIS_DIR/../global_assets"
        ./build.sh
        cd "$THIS_DIR"
else
        echo "ERROR: Missing global assets directory at $THIS_DIR/../global_assets"
        exit 1
fi
echo "Rebuilding global assets done."
echo "- - - - - - - - - - - - - - - - - - - - - - - -"
echo #

echo "Building blog post snippets..."
./build_snippets.sh
echo #
echo "Blog post snippets built."
echo "- - - - - - - - - - - - - - - - - - - - - - - -"
echo #

echo "Building blog pages..."
FOOTER_FILE="$THIS_DIR/../global_assets/build/footer.html"
HEADER_FILE="$THIS_DIR/../global_assets/build/header.html"
STYLE_FILE="$THIS_DIR/../global_assets/build/style.html"
TEMPLATE_FILE="$THIS_DIR/../global_assets/templates/landing.html"

echo "Copying global logo and favicon..."
cp "$THIS_DIR/../global_assets/build/logo.png" "$THIS_DIR/build/logo.png"
cp "$THIS_DIR/../global_assets/build/favicon.png" "$THIS_DIR/build/favicon.png"
echo "Copying logo assets done."
echo #

# Build individual posts
echo "Building individual posts..."
for post_dir in "$THIS_DIR/pages/posts/"*; do
    if [ -d "$post_dir" ]; then
        post_name=$(basename "$post_dir")
        if [ "$post_name" == "template_dir" ]; then
            continue
        fi

        post_file="$post_dir/post.md"
        if [ -f "$post_file" ]; then
            echo #
            echo "Processing post: $post_name"
            mkdir -p "$THIS_DIR/build/posts/$post_name"
            
            # Copy assets (like images) if any
            cp "$post_dir/"* "$THIS_DIR/build/posts/$post_name/" 2>/dev/null || true
            rm "$THIS_DIR/build/posts/$post_name/post.md" 2>/dev/null || true

            pandoc -f gfm -t html \
                --template="$TEMPLATE_FILE" \
                --include-in-header="$STYLE_FILE" \
                --include-before-body="$HEADER_FILE" \
                --include-after-body="$FOOTER_FILE" \
                -o "$THIS_DIR/build/posts/$post_name/index.html" \
                "$post_file"
        fi
    fi
done
echo #
echo "Individual posts built."
echo #

# Build All Snippets (Archive)
echo "Preparing archive snippets..."
echo #
ALL_SNIPPETS_FILE="$THIS_DIR/build/all_snippets.html"
ls -r "$THIS_DIR/build/snippets/"*.snippet.html 2>/dev/null > "$THIS_DIR/build/snippet_list.txt" || true
if [ -s "$THIS_DIR/build/snippet_list.txt" ]; then
    xargs cat < "$THIS_DIR/build/snippet_list.txt" > "$ALL_SNIPPETS_FILE"
    echo "Found $(wc -l < "$THIS_DIR/build/snippet_list.txt") snippets for archive."
else
    echo "WARNING: No snippets found for archive."
    echo "" > "$ALL_SNIPPETS_FILE"
fi

# Build Latest Snippet (Landing)
echo "Preparing latest snippet..."
LATEST_SNIPPET_FILE="$THIS_DIR/build/latest_snippet.html"
if [ -s "$THIS_DIR/build/snippet_list.txt" ]; then
    head -n 1 "$THIS_DIR/build/snippet_list.txt" | xargs cat > "$LATEST_SNIPPET_FILE"
else
    echo "" > "$LATEST_SNIPPET_FILE"
fi

echo #
echo "All snippets prepared."
echo "- - - - - - - - - - - - - - - - - - - - - - - -"
echo #

# Build Landing Page
echo "Building landing page..."
LANDING_MD_TMP="$THIS_DIR/build/landing_tmp.md"
cp "$THIS_DIR/pages/landing.md" "$LANDING_MD_TMP"
if grep -q "\[Latest Post Preview Placeholder\]" "$LANDING_MD_TMP"; then
    # Replace the line containing the placeholder with the content of the snippet
    sed -i -e "/\[Latest Post Preview Placeholder\]/r $LATEST_SNIPPET_FILE" -e "/\[Latest Post Preview Placeholder\]/d" "$LANDING_MD_TMP"
fi

pandoc -f gfm -t html \
    --template="$TEMPLATE_FILE" \
    --include-in-header="$STYLE_FILE" \
    --include-before-body="$HEADER_FILE" \
    --include-after-body="$FOOTER_FILE" \
    -o "$THIS_DIR/build/landing.html" \
    "$LANDING_MD_TMP"

echo #
echo "Landing page built."
echo "- - - - - - - - - - - - - - - - - - - - - - - -"
echo #

# Build Contents Table (Archive Page)
echo "Building archive page..."
echo #
CONTENTS_MD_TMP="$THIS_DIR/build/contents_tmp.md"
cp "$THIS_DIR/pages/contents.md" "$CONTENTS_MD_TMP"
if grep -q "\[All Posts Placeholder\]" "$CONTENTS_MD_TMP"; then
    # Replace the line containing the placeholder with the content of the snippets
    sed -i -e "/\[All Posts Placeholder\]/r $ALL_SNIPPETS_FILE" -e "/\[All Posts Placeholder\]/d" "$CONTENTS_MD_TMP"
fi

pandoc -f gfm -t html \
    --template="$TEMPLATE_FILE" \
    --include-in-header="$STYLE_FILE" \
    --include-before-body="$HEADER_FILE" \
    --include-after-body="$FOOTER_FILE" \
    -o "$THIS_DIR/build/ContentsTable/index.html" \
    "$CONTENTS_MD_TMP"

echo "Archive page built."
echo #

echo "Building blog pages done."
echo "- - - - - - - - - - - - - - - - - - - - - - - -"
echo #

echo "Blog web service building script finished"
echo "------------------------------------------------"
exit 0
