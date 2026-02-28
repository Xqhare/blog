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
echo "Individual posts built."
echo #

# Build All Snippets (Archive)
echo "Preparing archive snippets..."
ALL_SNIPPETS_FILE="$THIS_DIR/build/all_snippets.html"
echo "" > "$ALL_SNIPPETS_FILE"
for snippet in $(ls -r "$THIS_DIR/build/snippets/"*.snippet.html 2>/dev/null); do
    cat "$snippet" >> "$ALL_SNIPPETS_FILE"
done

# Build Latest Snippet (Landing)
echo "Preparing latest snippet..."
LATEST_SNIPPET_FILE="$THIS_DIR/build/latest_snippet.html"
ls -r "$THIS_DIR/build/snippets/"*.snippet.html 2>/dev/null | head -n 1 | xargs cat > "$LATEST_SNIPPET_FILE" 2>/dev/null

# Build Landing Page
echo "Building landing page..."
LANDING_MD_TMP="$THIS_DIR/build/landing_tmp.md"
cp "$THIS_DIR/pages/landing.md" "$LANDING_MD_TMP"
# Use a placeholder in the landing.md to insert the snippets
if grep -q "\[Latest Post Preview Placeholder\]" "$LANDING_MD_TMP"; then
    sed -i "/\[Latest Post Preview Placeholder\]/r $LATEST_SNIPPET_FILE" "$LANDING_MD_TMP"
    sed -i "s/\[Latest Post Preview Placeholder\]//" "$LANDING_MD_TMP"
fi

pandoc -f gfm -t html \
    --template="$TEMPLATE_FILE" \
    --include-in-header="$STYLE_FILE" \
    --include-before-body="$HEADER_FILE" \
    --include-after-body="$FOOTER_FILE" \
    -o "$THIS_DIR/build/landing.html" \
    "$LANDING_MD_TMP"

echo "Landing page built."
echo #

# Build Contents Table (Archive Page)
echo "Building archive page..."
CONTENTS_MD_TMP="$THIS_DIR/build/contents_tmp.md"
cp "$THIS_DIR/pages/contents.md" "$CONTENTS_MD_TMP"
if grep -q "\[All Posts Placeholder\]" "$CONTENTS_MD_TMP"; then
    sed -i "/\[All Posts Placeholder\]/r $ALL_SNIPPETS_FILE" "$CONTENTS_MD_TMP"
    sed -i "s/\[All Posts Placeholder\]//" "$CONTENTS_MD_TMP"
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
