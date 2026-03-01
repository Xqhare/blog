# Blog

Blog page service for xqhare.net.

The page is updated using a `post-receive` hook on the `gitea` server.

For more details [see here](https://github.com/xqhare/xqhare.net/).

Every blog post is converted into a full HTML file, as well as an HTML snippet for previews.

## Structure

A blog requires a somewhat different structure from the rest of the project.

The structure shown below is the finished HTML structure for the blog pages (managed via symlinks).

- `blog/`
  - `index.html` - landing page for the blog (features the latest post preview)
  - `ContentsTable/`
    - `index.html` - blog archive (all blog posts as previews, newest first)
  - `posts/`
    - `[post_name]/`
      - `index.html` - the full blog post
      - assets (images, etc.)

Source structure:

- `blog/`
    - `pages/`
      - `landing.md` - source for the blog home
      - `contents.md` - source for the archive page
      - `posts/`
        - `[post_name]/`
          - `post.md`
          - `asset.png`
    - `build.sh` - main build orchestrator
    - `build_snippets.sh` - handles metadata extraction and snippet rendering
    - `deploy.sh` - atomic deployment using timestamped data directories
    - `rollback.sh` - reverts to the previous version

## Blog post previews / snippets

All markdown posts start with a YAML block.

Required fields:

- `title`: URL-friendly slug (no spaces)
- `display_title`: The readable title
- `date`: YYYY-MM-DD
- `author`: Author name
- `tags`: [list, of, tags]
- `featured_image`: Path to the image file (optional)
- `abstract`: Brief summary for the snippet

### Visuals

Featured images in snippets are automatically scaled to a max height of 200px.
Full posts use a responsive layout optimized for both desktop and mobile devices.
