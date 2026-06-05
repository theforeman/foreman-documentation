#!/usr/bin/env ruby
# Build script for Contributors' Guide
# Concatenates markdown sources and converts to HTML

require 'kramdown'
require 'fileutils'

# Paths
ROOT_DIR = File.expand_path('../..', __dir__)
GUIDES_BUILD_DIR = File.join(File.dirname(__dir__), 'build')
OUTPUT_DIR = File.join(GUIDES_BUILD_DIR, 'Contributing')
OUTPUT_FILE = File.join(OUTPUT_DIR, 'index.html')
TEMPLATE_FILE = File.join(__dir__, 'template.html')

# Source files
CONTRIBUTING_MD = File.join(ROOT_DIR, 'CONTRIBUTING.md')
SKILLS_DIR = File.join(ROOT_DIR, '.claude', 'skills')
VALE_RULES_DIR = File.join(ROOT_DIR, '.vale', 'styles', 'foreman-documentation')

def strip_frontmatter(content)
  # Remove YAML frontmatter between --- delimiters
  content.sub(/\A---\s*\n.*?\n---\s*\n/m, '')
end

def read_skill_files
  skills = []
  return skills unless Dir.exist?(SKILLS_DIR)

  Dir.glob(File.join(SKILLS_DIR, '*', 'SKILL.md')).sort.each do |skill_file|
    skill_name = File.basename(File.dirname(skill_file))
    content = File.read(skill_file)
    content = strip_frontmatter(content)

    skills << {
      name: skill_name,
      content: content
    }
  end

  skills
end

def read_vale_rules
  rules = []
  return rules unless Dir.exist?(VALE_RULES_DIR)

  Dir.glob(File.join(VALE_RULES_DIR, '*.yml')).sort.each do |rule_file|
    rule_name = File.basename(rule_file, '.yml')
    content = File.read(rule_file)

    rules << {
      name: rule_name,
      content: content
    }
  end

  rules
end

def build_markdown
  markdown = []

  # Add title
  markdown << "# Contributors' Guide"
  markdown << ""
  markdown << "This guide consolidates contribution resources for the Foreman Documentation project."
  markdown << "It concatenates resources from the following sources:"
  markdown << " - [CONTRIBUTING.md](../../CONTRIBUTING.md)"
  markdown << " - [Documentation Skills](../../.claude/skills)"
  markdown << " - [Vale Rules for Foreman documentation](../../.vale/styles/foreman-documentation)"
  markdown << ""
  markdown << "Last updated: #{Time.now.strftime('%Y-%m-%d')}"
  markdown << ""
  markdown << "---"
  markdown << ""

  # Add CONTRIBUTING.md
  if File.exist?(CONTRIBUTING_MD)
    markdown << File.read(CONTRIBUTING_MD)
    markdown << ""
    markdown << "---"
    markdown << ""
  end

  # Add skills section
  skills = read_skill_files
  unless skills.empty?
    markdown << "# Documentation Skills"
    markdown << ""
    markdown << "The repository includes specialized skills (slash commands) for common documentation tasks."
    markdown << "These can be invoked in AI-assisted editors like Claude Code or Cursor."
    markdown << ""

    skills.each do |skill|
      markdown << "## Skill: #{skill[:name]}"
      markdown << ""
      markdown << skill[:content]
      markdown << ""
    end

    markdown << "---"
    markdown << ""
  end

  # Add Vale rules section
  rules = read_vale_rules
  unless rules.empty?
    markdown << "# Project-Specific Vale Rules"
    markdown << ""
    markdown << "The following custom Vale rules enforce documentation standards specific to Foreman."
    markdown << "These rules are located in `.vale/styles/foreman-documentation/`."
    markdown << ""

    rules.each do |rule|
      markdown << "## Rule: #{rule[:name]}"
      markdown << ""
      markdown << "**File:** `.vale/styles/foreman-documentation/#{rule[:name]}.yml`"
      markdown << ""
      markdown << "```yaml"
      markdown << rule[:content]
      markdown << "```"
      markdown << ""
    end
  end

  markdown.join("\n")
end

def convert_to_html(markdown_content)
  # Convert markdown to HTML using kramdown
  doc = Kramdown::Document.new(
    markdown_content,
    input: 'GFM',
    syntax_highlighter: 'rouge',
    syntax_highlighter_opts: {
      line_numbers: false,
      css_class: 'highlight'
    },
    auto_ids: true,
    toc_levels: (1..3).to_a
  )

  doc.to_html
end

def generate_toc(markdown_content)
  # Extract headings for TOC
  toc = []
  markdown_content.each_line do |line|
    # Match markdown headings (# through ###)
    if line =~ /^(\#{1,3})\s+(.+)$/
      level = $1.length
      title = $2.strip
      # Create anchor from title
      anchor = title.downcase.gsub(/[^\w\s-]/, '').gsub(/\s+/, '-')
      toc << { level: level, title: title, anchor: anchor }
    end
  end
  toc
end

def inject_into_template(html_content, markdown_content)
  unless File.exist?(TEMPLATE_FILE)
    puts "Warning: Template file not found at #{TEMPLATE_FILE}"
    puts "Creating basic HTML output without template."
    return "<html><body>#{html_content}</body></html>"
  end

  template = File.read(TEMPLATE_FILE)
  toc = generate_toc(markdown_content)

  # Build TOC HTML
  toc_html = toc.map do |item|
    indent = '  ' * (item[:level] - 1)
    "#{indent}<li class=\"toc-level-#{item[:level]}\"><a href=\"##{item[:anchor]}\">#{item[:title]}</a></li>"
  end.join("\n")

  # Replace placeholders in template
  template.gsub!('{{CONTENT}}', html_content)
  template.gsub!('{{TOC}}', toc_html)
  template.gsub!('{{BUILD_DATE}}', Time.now.strftime('%Y-%m-%d %H:%M:%S'))

  template
end

# Main build process
def build
  puts "Building Contributors' Guide..."

  # Create output directory
  FileUtils.mkdir_p(OUTPUT_DIR)

  # Build markdown content
  puts "  - Concatenating markdown sources..."
  markdown_content = build_markdown

  # Convert to HTML
  puts "  - Converting to HTML..."
  html_content = convert_to_html(markdown_content)

  # Inject into template
  puts "  - Applying template..."
  final_html = inject_into_template(html_content, markdown_content)

  # Write output
  puts "  - Writing to #{OUTPUT_FILE}..."
  File.write(OUTPUT_FILE, final_html)

  puts "Build complete! Output: #{OUTPUT_FILE}"
  puts "  Size: #{File.size(OUTPUT_FILE)} bytes"
end

# Run build
build
