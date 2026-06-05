# Contributors' Guide

This directory contains a standalone guide for documentation contributors that consolidates all contribution resources into a single HTML page.

## What's Included

The guide automatically combines:

- **CONTRIBUTING.md** - Introduction to contribution guidelines
- **Documentation Skills** - All slash commands in `.claude/skills/*/SKILL.md`
- **Vale Rules** - Project-specific linting rules in `.vale/styles/foreman-documentation/`

## Building Locally

### Build the guide:

```bash
cd guides/doc-Contributing
make html
```

Output: `guides/build/Contributing/index.html`

**Note:** `make html` only rebuilds if source files have changed. If you want to force a fresh build, clean build artifacts first:

```bash
make clean && make html
```

Otherwise, you'll get an error "Nothing to be done for 'html'"

### View the guide:

```bash
make serve
# Opens at http://localhost:8813
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
├── README.md          # This file
├── Makefile           # Build system with dependency tracking
├── build.rb           # Ruby script: concatenate markdown → HTML
├── template.html      # HTML5 template with CSS and TOC
└── build/             # Generated output (gitignored)
    └── index.html     # Final HTML guide
```

## How It Works

1. **build.rb** reads and concatenates:
   - CONTRIBUTING.md content
   - All skill files (strips YAML frontmatter)
   - Vale rules (formatted as YAML code blocks)

2. **kramdown** converts the combined markdown to HTML

3. **template.html** wraps the HTML with:
   - Responsive CSS styling
   - Table of contents sidebar
   - Syntax highlighting

4. Output written to `guides/build/Contributing/index.html`

## Integration with Main Build

The contributors' guide is built alongside other guides:

```bash
# From repository root
make html              # Builds all guides + contributors' guide
make build-foreman-el  # Builds foreman-el guides + contributors' guide
```

The `guides/Makefile` excludes `doc-Contributing` from the BUILD matrix and builds it separately via the `contributing` target.

## Troubleshooting

### Make says "Nothing to be done for 'html'"

This is normal! Make only rebuilds when source files have changed since the last build. 

**To force a rebuild:**
```bash
make clean && make html
```

**To verify auto-rebuild works:**
1. Modify a source file: `touch ../../CONTRIBUTING.md`
2. Run `make html` - should rebuild
3. Run `make html` again - should say "Nothing to be done" (correct!)

### Build fails with "kramdown not found"

Run `bundle install` from the repository root to install dependencies.

### Output file not updating after source changes

Check that source files are actually newer than the output:
```bash
stat -c '%Y' ../../CONTRIBUTING.md ../build/Contributing/index.html
```

The source timestamp should be larger (newer) than the output timestamp.

### Serve port already in use

The default port is 8813. Change it:
```bash
python3 -m http.server --directory ../build/Contributing 9000
```

## Adding New Content

### Add a new skill:

1. Create `.claude/skills/new-skill/SKILL.md`
2. Run `make html` - automatically detected and included

### Add a new Vale rule:

1. Create `.vale/styles/foreman-documentation/NewRule.yml`
2. Run `make html` - automatically detected and included

## Questions?

- For build system questions: See `guides/common/Makefile` for AsciiDoc guide patterns
- For markdown syntax: See [kramdown documentation](https://kramdown.gettalong.org/)
- For contribution questions: Read the generated guide at `guides/build/Contributing/index.html`
