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
