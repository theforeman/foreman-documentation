SHELL := /bin/bash
BUILD_DIR = ../build/Contributing
OUTPUT = $(BUILD_DIR)/index.html

# Find all skill files and vale rules dynamically
SKILL_FILES = $(shell find ../../.cursor/skills -name 'SKILL.md' 2>/dev/null)
VALE_RULES = $(shell find ../../.vale/styles/foreman-documentation -name '*.yml' 2>/dev/null)
SOURCES = build.rb template.html ../../CONTRIBUTING.md $(SKILL_FILES) $(VALE_RULES)

.PHONY: all html clean serve

all: html

html: $(OUTPUT)

$(OUTPUT): $(SOURCES)
	@mkdir -p $(BUILD_DIR)
	bundle exec ruby build.rb

clean:
	@rm -rf $(BUILD_DIR)

serve: html
	@echo "Serving Contributors' Guide at http://localhost:8813"
	@echo "Press Ctrl+C to stop"
	python3 -m http.server --directory $(BUILD_DIR) 8813
