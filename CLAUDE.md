# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a documentation repository for the Foreman project and its downstream products (Katello, Satellite, orcharhino). Documentation is written in AsciiDoc and follows the [modular documentation framework](https://redhat-documentation.github.io/modular-docs/).

## Build Commands

### Prerequisites (macOS)

```bash
brew install ruby make
echo 'export PATH="/opt/homebrew/opt/ruby/bin:$PATH"' >> ~/.zshrc
# Then restart terminal and install gems:
make prep
```

### Building guides

```bash
# Build a single guide (run from a doc-*/ subdirectory)
make BUILD=foreman-el

# Build all guides (run from guides/)
make html

# Build all guides for a specific target
make BUILD=katello  # options: foreman-el (default), foreman-deb, katello, satellite, orcharhino

# Open built guide in browser (from a doc-*/ subdirectory)
make browser

# Parallel build (recommended)
make -j9

# Clean build artifacts
make clean
```

### Full site (root Makefile)

```bash
make serve         # builds everything and serves at http://localhost:5000
make html          # builds all guide variants
make web           # builds the static landing site
PORT=5008 make serve  # use a custom port
```

### Container build (alternative)

```bash
podman build --tag foreman_documentation .
rm -rf guides/build && podman run --rm -v $(pwd):/foreman-documentation foreman_documentation make html
```

### Vale linting

Vale linting runs automatically in CI on PRs. To run locally:

```bash
vale guides/common/modules/your-file.adoc
vale --config=.vale-dita.ini guides/common/modules/your-file.adoc
```

The Vale config at `.vale.ini` uses the `RedHat`, `AsciiDoc`, and `foreman-documentation` style packages.

### Link checking

```bash
# Run from guides/ after building HTML
make linkchecker
```

## Repository Structure

```
guides/
  common/            # Shared content included by all guides
    assembly_*.adoc  # Assemblies (user stories that include modules)
    modules/         # Individual content modules
      con_*.adoc     # Concept modules (what/why)
      proc_*.adoc    # Procedure modules (how-to steps)
      ref_*.adoc     # Reference modules (tables, lists)
      snip_*.adoc    # Snippets (reusable admonitions, no ID)
    attributes.adoc           # Version numbers, includes other attribute files
    attributes-base.adoc      # Base attributes for all builds
    attributes-foreman-el.adoc
    attributes-foreman-deb.adoc
    attributes-katello.adoc
    attributes-satellite.adoc
    attributes-orcharhino.adoc
    attributes-titles.adoc
  doc-*/             # Individual guides, each with:
    master.adoc      # Top-level file for the guide
    common -> ../common  (symlink)
    images/
    images/common -> ../common/images  (symlink)
    Makefile         # includes ../common/Makefile
  build/             # Generated HTML output (gitignored)
web/                 # Static landing page (nanoc site)
.vale/
  styles/
    foreman-documentation/  # Custom Vale rules
    config/vocabularies/Foreman/  # accept.txt, reject.txt
.vale.ini            # Vale configuration for AsciiDoc
.vale-dita.ini       # Vale configuration for DITA structure checks
```

## Content Architecture

### Multi-target builds

The same source files build documentation for multiple products. **Never use product names directly** — always use AsciiDoc attributes:

- `{Project}` — product name (Foreman, Satellite, orcharhino)
- `{ProjectServer}`, `{SmartProxy}`, `{ProjectWebUI}` — component names
- `{ProjectVersion}`, `{KatelloVersion}` — version numbers

Build targets: `foreman-el`, `foreman-deb`, `foremanctl-katello`, `foremanctl-orcharhino`, `foremanctl-satellite`, `katello`, `satellite`, `orcharhino`

### Conditional content

```asciidoc
ifdef::katello[]
Content only for Katello builds.
endif::[]

ifndef::satellite[]
Content for all builds except Satellite.
endif::[]

// Logic OR:
ifdef::katello,satellite[]
Content for Katello or Satellite builds.
endif::[]
```

### Using attributes in code blocks

```asciidoc
[options="nowrap" subs="+quotes,attributes"]
----
# command {AttributeName}
----
```

### Module file structure

Each module file starts with a content-type attribute on line 1:

```asciidoc
:_mod-docs-content-type: CONCEPT
[id="my-topic_{context}"]
= My topic title
```

Snippets (`snip_`) must not contain an ID.

## Cursor Commands (`.cursor/commands/`)

These commands describe common refactoring patterns:

- **`abstract.md`** — review/write short descriptions (50–300 chars, user-centric, no self-referential language)
- **`refactor-adoc.md`** — rename a file, update its ID, title, and all `include::` references across the repo
- **`split-web-ui-cli.md`** — split a procedure into separate web UI (`proc_*-by-using-web-ui.adoc`) and CLI (`proc_*-by-using-cli.adoc`) files

## Writing Conventions

- One sentence per line in source files.
- Use underscores for variable user input: `hammer org create --name "_My_Organization_"`
- No trailing whitespace.
- UTF-8 encoding.
- IDs use lowercase kebab-case: `[id="my-topic_{context}"]`
- Surround variable parts of IDs with `_{context}` (appended by the include mechanism).
- Web UI and CLI procedures for the same task are split into separate files named `proc_*-by-using-web-ui.adoc` and `proc_*-by-using-cli.adoc`.

## Branching Model

- `master` = nightly (current development)
- `X.Y` branches = stable releases (e.g., `3.18`)
- Versions are set in `guides/common/attributes.adoc` (`ProjectVersion`, `KatelloVersion`)
- PR descriptions include a cherry-pick list indicating which versions the change applies to
