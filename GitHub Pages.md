---
slug: github-pages
---

[GitHub Pages](https://pages.github.com/) is an easy way to deploy and host static websites on GitHub.

See [our CI configuration](https://github.com/srid/emanote-template/blob/master/.github/workflows/publish.yaml).

Check `flake.nix` where we specify a base URL since, without CNAME, the default `github.io` domain will publish the site under a sub-path.
