# Find all skill files and vale rules dynamically
SKILL_FILES = $(shell find ../../.claude/skills -name 'SKILL.md')
VALE_RULES = $(shell find ../../.vale/styles/foreman-documentation -name '*.yml')
BUILD_SOURCES = build.rb ../../CONTRIBUTING.md $(SKILL_FILES) $(VALE_RULES)

include ../common/Makefile

# Generate AsciiDoc from Markdown sources after prepare creates directories
topics/contributing-generated.adoc: $(BUILD_SOURCES) | prepare
	@mkdir -p topics
	@echo "Generating AsciiDoc from Markdown sources..."
	bundle exec ruby build.rb

# Ensure the generated file exists before building HTML
$(DEST_HTML): topics/contributing-generated.adoc
