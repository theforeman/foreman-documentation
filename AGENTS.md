- Follow the checklists and technical/style-review guidance in
  [CONTRIBUTING.md](CONTRIBUTING.md).
- Use [guides/README.md](guides/README.md) and the
  [Contributors' Guide](guides/doc-Contributing/) for documentation structure
  and AsciiDoc conventions.
- Treat [.vale.ini](.vale.ini) and the project [Vale rules](.vale/styles/foreman-documentation/)
  as the style authority.
- ALWAYS run `make -C guides/XXX` of all changed guides after changes.
- Avoid `make html` unless necessary, it is very slow.
- ALWAYS run `make vale`, and
  [check-filename-id-heading-match.sh](scripts/check-filename-id-heading-match.sh).
