# emanote-template

A template repository to create your own Markdown-based [Emanote](https://github.com/srid/emanote) notebook with [Visual Studio Code](https://code.visualstudio.com/) support, as well as to publish it to GitHub Pages.

See https://emanote.srid.ca/resources/emanote-template for details.

## Using this template

Click the "Use this template" green button on Github, and in the resulting repository make the following modifications,

1. Change `content/index.yaml` to use your site's title (and set the same in `content/index.md`) and a suitable edit URL.
1. Start adding notes to `./content` (where all notes should live).

If deploying using GitHub Pages, also:

1. Change `.deploy/github/index.yaml` to change the `baseUrl` (if your repository is named differently or you are using a CNAME). If you are using CNAME (with no sub-path), then you may get rid of the `.deploy/github` layer entirely (be sure to update `.github/workflows/publish.yaml` accordingly).

Checkout [examples](https://emanote.srid.ca/examples) and [demo](https://emanote.srid.ca/demo) for next steps.

## Running using Nix

To start the Emanote live server using Nix:

```sh
# If you using VSCode, you can also: Ctrl+Shift+B
nix run
```

To update Emanote version in flake.nix:

```sh
nix flake lock --update-input emanote
```

To build the static website via Nix:

```sh
nix build -o ./result
# Then test it:
nix run nixpkgs#nodePackages.live-server -- ./result
```

## GitHub Pages

GitHub Actions CI is responsible for deploying to GitHub Pages. See `.github/workflows/publish.yaml`.
