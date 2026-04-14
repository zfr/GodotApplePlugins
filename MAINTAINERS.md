# Maintainers Guide

## Documentation

To build the API documentation locally, run:

```sh
make -C doctools html
```

The local docs tool defaults to `$(HOME)/cvs/master-godot/doc/classes` when that exists, and falls back to `$(HOME)/cvs/master-godot/editor/doc/classes` for older checkouts. You can override that path, or the HTML output directory, when needed:

```sh
make -C doctools html GODOT_DOCS_SOURCE=/path/to/godot/doc/classes
make -C doctools html GODOT_DOCS_SOURCE=/path/to/godot/doc/classes HTML_OUTPUT=../site
```

To publish the generated docs to the `docs` branch without switching your current checkout, run:

```sh
make deploy-docs
```

This builds the site into a temporary directory, updates the `docs/` folder on the `docs` branch through a temporary `git worktree`, commits only when the generated output changed, and pushes to `origin/docs`. The repository Pages source should be set to the `docs` branch and the `/docs` folder.
