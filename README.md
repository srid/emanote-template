# emanote-template

Notebook template for https://github.com/srid/emanote - to easily get started with publishing GitHub Pages website using Emanote out of plain-text notes.

## Using this template

CLick the "Use this template" green button on Github, and in the resulting repository make the following modifications,

1. Change `index.yaml` to use your site's title (and set the same in `index.md`)
2. Change `.deploy/github/index.yaml` to change the `baseUrl` (if your repository is named differently or you are using a CNAME). If you are using CNAME (with no sub-path), then you may get rid of the `.deploy/github` layer entirely (be sure to update `publish.yaml` accordingly).
3. Delete `README.md` (this file)
