SHELL := /bin/bash

# Include standard AsciiDoc build system first to get its default targets
include ../common/Makefile

# Find all skill files and vale rules dynamically
SKILL_FILES = $(shell find ../../.claude/skills -name 'SKILL.md' 2>/dev/null)
VALE_RULES = $(shell find ../../.vale/styles/foreman-documentation -name '*.yml' 2>/dev/null)
BUILD_SOURCES = build.rb ../../CONTRIBUTING.md $(SKILL_FILES) $(VALE_RULES)

# Generate AsciiDoc from Markdown sources before building
topics/contributing-generated.adoc: $(BUILD_SOURCES)
	@echo "Generating AsciiDoc from Markdown sources..."
	bundle exec ruby build.rb

# Make master.adoc depend on the generated file to ensure it's created before any build
master.adoc: topics/contributing-generated.adoc

# Also hook into prepare target for explicit prepare calls
prepare: topics/contributing-generated.adoc
