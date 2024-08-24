---
page:
  headHtml: |
    <snippet var="js.highlightjs" />
---
By default the filesystem path is used to determine the note URL. You can override this using the `slug` frontmatter metadata.

## Overriding the URL

For example,

- Source: https://raw.githubusercontent.com/srid/srid/master/free/Actualism%20Method.md
- Rendered: https://srid.ca/method

Notice that in the source, we see:

```yaml
---
slug: method
---
```

This makes Emanote use `/method` as the URL path for this note. Without this, by default, Emanote would use `/free/Actualism%20Method`.

