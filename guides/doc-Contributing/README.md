# Contributors' Guide

This directory contains a guide for documentation contributors that consolidates all contribution resources using the standard Foreman documentation build system.

## What's Included

The guide automatically combines:

- **CONTRIBUTING.md** - Introduction to contribution guidelines
- **Documentation Skills** - All slash commands in `.claude/skills/*/SKILL.md`
- **Vale Rules** - Project-specific linting rules in `.vale/styles/foreman-documentation/`

Skills are automatically organized into categories in the generated guide for easier navigation.

## Building Locally

### Build the guide:

```bash
cd guides/doc-Contributing
make html
```

Output: `guides/build/Contributing/index-{BUILD}.html`

The guide uses the standard AsciiDoc build system, so you can build for different contexts:

```bash
make html BUILD=foreman-el   # Default
make html BUILD=katello
make html BUILD=satellite
```

### View the guide:

```bash
make serve
# Opens at http://localhost:8813
```

Or use the standard browser target:

```bash
make browser BUILD=foreman-el
```

## Auto-Rebuild

The guide **automatically rebuilds** when source files change:

### On GitHub (CI/CD)

When you push changes to:
- `CONTRIBUTING.md`
- Any skill file (`.claude/skills/*/SKILL.md`)
- Any Vale rule (`.vale/styles/foreman-documentation/*.yml`)

GitHub Actions will:
1. Detect the change via Makefile dependencies
2. Rebuild the guide automatically
3. Include it in PR previews

No manual intervention needed!

### Locally

The Makefile tracks dependencies automatically. Running `make html` will:
- Check if source files changed since last build
- Rebuild only if needed
- Skip if already up-to-date

## File Structure

```
guides/doc-Contributing/
├── README.md                        # This file
├── Makefile                         # Build system with dependency tracking
├── build.rb                         # Ruby script: concatenate markdown → AsciiDoc
├── master.adoc                      # Main AsciiDoc file
├── topics/
│   └── contributing-generated.adoc  # Generated AsciiDoc content
├── common -> ../common              # Symlink to shared content
└── images/
    └── common -> ../../common/images  # Symlink to shared images
```

## How It Works

1. **build.rb** reads and concatenates:
   - CONTRIBUTING.md content
   - All skill files (strips YAML frontmatter, extracts Overview/Examples sections)
   - Vale rules (formatted as YAML code blocks)

2. **kramdown-asciidoc** converts the combined markdown to AsciiDoc

3. Output written to `topics/contributing-generated.adoc`

4. **master.adoc** includes the generated content

5. **Foreman-documentation AsciiDoc build system** converts to HTML with consistent styling

## Troubleshooting

### Build fails with "kramdown-asciidoc not found"

Run `bundle install` from the repository root to install dependencies.
