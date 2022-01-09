# emanote-template

A template repository to create your own Markdown-based [Emanote](https://github.com/srid/emanote) notebook with VSCode support, as well as to publish it to GitHub Pages.

See https://emanote.srid.ca/resources/emanote-template for details.

## Using this template

Click the "Use this template" green button on Github, and in the resulting repository make the following modifications,

1. Change `index.yaml` to use your site's title (and set the same in `index.md`)
2. Change `.deploy/github/index.yaml` to change the `baseUrl` (if your repository is named differently or you are using a CNAME). If you are using CNAME (with no sub-path), then you may get rid of the `.deploy/github` layer entirely (be sure to update `publish.yaml` accordingly).
3. Delete `README.md` (this file)

Checkout [examples](https://emanote.srid.ca/examples) and [demo](https://emanote.srid.ca/demo) for next steps.
