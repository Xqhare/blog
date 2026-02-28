# Blog

Blog page service for xqhare.net.

This service is used to host a GitHub README as a HTML page.

The page is updated using a `post-receive` hook on the `gitea` server.

For more details [see here](https://github.com/xqhare/xqhare.net/).

Every blog post can be converted into a full HTML file, as well as an HTML snippet for previews.

## Structure

A blog requires a somewhat different structure from the rest of the project.

The structure shown below is the finished HTML structure for the blog pages.

- `blog/`
  - `index.html` - landing page for the blog (mainly static with a preview of the latest post and a link to the table of contents)
  - `ContentsTable/`
    - `index.html` - table of contents for the blog (all blog posts as previews ordered with the latest on top)
  - `posts/`
    - `post1/` - the name would be the title of the blog post
      - all data needed for the post

- blog
    - pages / posts (markdown content)
      - landing.md - landing page for the blog
      - post1/
        - post1.md
        - asset.png
    - HTML (not part of the repo - the build script creates all content inside this directory as symlinks)
    - build.sh, etc. (build scripts)
    - README.md
    - docker compose (using nginx; pointing to `html` directory)
    - (data & build directories) not part of the repo - constructed using the scripts

## Blog post previews / snippets

All markdown posts will start with a YAML block.

The block will have the following fields:

- title
- display_title
- date
- author
- tags
- featured_image
- abstact

This data will be used to generate a preview for the blog post.

### Size

Every snippet will be given a max height of 125px (width set automatically) for its featured image.
A snippet itself does not have a set max size.
