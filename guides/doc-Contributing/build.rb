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

def extract_guide_sections(content)
  # Extract only sections meant for the guide (#### Overview and #### Examples)
  lines = content.lines
  result = []
  capturing = false
  section_content = []

  lines.each do |line|
    # Check if this is a level-4 heading
    if line =~ /^####\s+(.+)$/
      heading = $1.strip

      # Save previous section if we were capturing
      if capturing && !section_content.empty?
        result.concat(section_content)
        section_content = []
      end

      # Start capturing if this is Overview or Examples (case-insensitive, flexible)
      if heading =~ /^Overview$/i || heading =~ /^Examples/i
        capturing = true
        section_content << line
      else
        capturing = false
      end
    # Check if this is a heading of level 1-3 (stops any section)
    elsif line =~ /^#\{1,3\}\s+/
      # Save previous section if we were capturing
      if capturing && !section_content.empty?
        result.concat(section_content)
        section_content = []
      end
      capturing = false
    # Regular content line
    elsif capturing
      section_content << line
    end
  end

  # Don't forget the last section
  if capturing && !section_content.empty?
    result.concat(section_content)
  end

  result.join
end

def extract_frontmatter_field(content, field)
  match = content.match(/\A---\s*\n(.*?)\n---\s*\n/m)
  return nil unless match

  match[1].each_line do |line|
    stripped = line.strip
    prefix = "#{field}:"
    next unless stripped.start_with?(prefix)

    return stripped[prefix.length..].strip
  end
  nil
end

def categorize_skill(skill_dir_name)
  # Map skill directory names to categories
  categories = {
    'abstract' => 'AI skills for style guidelines',
    'heading' => 'AI skills for style guidelines',
    'prerequisites' => 'AI skills for style guidelines',
    'review-assembly-user-story' => 'AI skills for structure',
    'split-web-ui-cli' => 'AI skills for structure',
    'refactor-adoc' => 'AI skills for file management',
    'validate-contribution' => 'AI skills for contribution guidelines'
  }

  categories[skill_dir_name] || 'Other'
end

def read_skill_files
  skills = []
  skipped = []
  return skills unless Dir.exist?(SKILLS_DIR)

  # Look for skills: .claude/skills/skill-name/SKILL.md
  Dir.glob(File.join(SKILLS_DIR, '*', 'SKILL.md')).sort.each do |skill_file|
    skill_dir_name = File.basename(File.dirname(skill_file))
    content = File.read(skill_file)
    skill_name = extract_frontmatter_field(content, 'name') || skill_dir_name
    content = strip_frontmatter(content)

    # Extract only guide-relevant sections (Overview and Examples)
    guide_content = extract_guide_sections(content)

    # Skip skills that have no guide content
    if guide_content.strip.empty?
      skipped << skill_name
      next
    end

    skills << {
      name: skill_name,
      dir_name: skill_dir_name,
      category: categorize_skill(skill_dir_name),
      content: guide_content
    }
  end

  # Report skipped skills
  unless skipped.empty?
    puts "  - Skipped #{skipped.length} skill(s) without Overview or Examples sections:"
    skipped.each { |name| puts "    - #{name}" }
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
  markdown << "# About the Foreman Documentation Contributors' Guide"
  markdown << ""
  markdown << "The Foreman Documentation Contributors' Guide consolidates contribution resources for the Foreman Documentation project. It consolidates resources from the following sources:"
  markdown << " - [CONTRIBUTING.md](../../CONTRIBUTING.md)"
  markdown << " - [Documentation Skills](../../.claude/skills)"
  markdown << " - [Vale Rules for Foreman documentation](../../.vale/styles/foreman-documentation)"
  markdown << ""
  markdown << "The guide concatenates resources from the above sources into a single guide for easy reference. For more information, see the [README](README.md)."
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
    # Group skills by category
    skills_by_category = skills.group_by { |skill| skill[:category] }

    # Define category order for consistent presentation
    category_order = ['AI skills for style guidelines', 'AI skills for structure', 'AI skills for file management', 'AI skills for contribution guidelines', 'Other']

    category_order.each do |category|
      next unless skills_by_category[category]

      markdown << "# #{category}"
      markdown << ""
      markdown << "The repository includes specialized skills (slash commands) for common documentation tasks."
      markdown << "These can be invoked in AI-assisted editors like Claude Code or Cursor."
      markdown << ""

      skills_by_category[category].each do |skill|
        markdown << "## #{skill[:name]}"
        markdown << ""
        markdown << skill[:content]
        markdown << ""
      end

      markdown << "---"
      markdown << ""
    end
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
