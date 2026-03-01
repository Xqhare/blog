# Blog (blog.xqhare.net)

## Project Overview
This directory contains the source content and configuration for Xqhare's personal blog.

## Directory Structure
- `pages/`: Contains the Markdown sources. `landing.md` for the home page, `contents.md` for the archive, and a `posts/` subdirectory for individual blog entries.
- `build.sh`: Main build orchestrator. Generates the landing page, the archive page (`ContentsTable`), and individual post HTML files using global templates.
- `build_snippets.sh`: Extracts YAML metadata from posts to build HTML preview snippets.
- `deploy.sh`: Handles atomic deployment using timestamped directories and symlinks in the `data/` and `html/` folders.
- `rollback.sh`: Reverts the `index.html`, `posts/`, and `ContentsTable/` symlinks to the previous deployment state.
- `hook.sh`: Triggered after a git push to rebuild and redeploy the blog.
- `README.md`: High-level overview of the blog's purpose and status.

## Usage
Blog posts are written in Markdown within `pages/posts/`. The `build.sh` script converts these posts into HTML using `pandoc` and the `blog_post.html` template. It also dynamically generates an index page and an archive page utilizing preview snippets. Deployed automatically via the project pipeline.
