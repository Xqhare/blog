# Blog (blog.xqhare.net)

## Project Overview
This directory contains the source content and configuration for Xqhare's personal blog.

## Directory Structure
- `build.sh`: Intended to iterate through blog posts and generate an `index.html`.
- `deploy.sh`: (Placeholder) Intended to deploy the generated HTML to the server.
- `hook.sh`: Triggered after a git push to rebuild and redeploy the blog.
- `README.md`: High-level overview of the blog's purpose and status.
- `LICENSE`: MIT License.

## Usage
Blog posts are written in Markdown. The `build.sh` script is planned to convert these posts into HTML using `pandoc` and automatically generate an index page for `blog.xqhare.net`. Deployed automatically via the `webpage` pipeline. Refer to [../webpage_startup_notes/GEMINI.md](../webpage_startup_notes/GEMINI.md) for technical details on the build and deployment process.
