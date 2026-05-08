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

def extract_visible_sections(content)
  # Extract sections meant to be visible (#### Overview and #### Examples)
  lines = content.lines
  result = []
  capturing = false
  section_content = []
  in_code_block = false

  lines.each do |line|
    # Track code blocks (````)
    if line.strip.start_with?('```')
      in_code_block = !in_code_block
      section_content << line if capturing
      next
    end

    # Skip heading detection inside code blocks
    if in_code_block
      section_content << line if capturing
      next
    end

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

def extract_ai_sections(content)
  # Extract sections meant for AI tools (everything EXCEPT Overview and Examples)
  lines = content.lines
  result = []
  capturing = true  # Start capturing by default
  section_content = []
  in_code_block = false

  lines.each do |line|
    # Track code blocks (````)
    if line.strip.start_with?('```')
      in_code_block = !in_code_block
      section_content << line if capturing
      next
    end

    # Skip heading detection inside code blocks
    if in_code_block
      section_content << line if capturing
      next
    end

    # Check if this is a level-4 heading
    if line =~ /^####\s+(.+)$/
      heading = $1.strip

      # Save previous section if we were capturing
      if capturing && !section_content.empty?
        result.concat(section_content)
        section_content = []
      end

      # Stop capturing if this is Overview or Examples (opposite of visible sections)
      if heading =~ /^Overview$/i || heading =~ /^Examples/i
        capturing = false
      else
        capturing = true
        section_content << line
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
    'personas' => 'AI skills for style guidelines',
    'review-assembly-user-story' => 'AI skills for structure',
    'split-web-ui-cli' => 'AI skills for file management',
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

    # Extract sections for human readers (Overview and Examples)
    visible_content = extract_visible_sections(content)

    # Extract sections for AI tools (everything else)
    ai_content = extract_ai_sections(content)

    # Skip skills that have no content at all
    if visible_content.strip.empty? && ai_content.strip.empty?
      skipped << skill_name
      next
    end

    skills << {
      name: skill_name,
      dir_name: skill_dir_name,
      category: categorize_skill(skill_dir_name),
      visible_content: visible_content,
      ai_content: ai_content
    }
  end

  # Report skipped skills
  unless skipped.empty?
    puts "  - Skipped #{skipped.length} skill(s) without any content:"
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

    # Extract description from YAML comments at the top
    description = []
    yaml_content = []
    in_yaml = false

    content.lines.each do |line|
      if line.strip.start_with?('#') && !in_yaml
        # Comment line before YAML starts
        description << line.sub(/^#\s*/, '').strip
      elsif line.strip == '---'
        # YAML document start
        in_yaml = true
        yaml_content << line
      elsif in_yaml
        # YAML content
        yaml_content << line
      end
    end

    rules << {
      name: rule_name,
      description: description.join(' '),
      yaml: yaml_content.join
    }
  end

  rules
end

def build_markdown
  markdown = []

  # Add title
  markdown << "# About the Foreman Documentation Contributors' Guide"
  markdown << ""
  markdown << "The Foreman Documentation Contributors' Guide consolidates contribution guidelines for the Foreman Documentation project from the following sources:"
  markdown << " - [CONTRIBUTING.md](../../CONTRIBUTING.md)"
  markdown << " - [Documentation AI Skills](../../.claude/skills)"
  markdown << " - [Vale Rules for Foreman documentation](../../.vale/styles/foreman-documentation)"
  markdown << ""
  markdown << "The guide concatenates resources from the above sources into a single guide for easy reference. When one of these resources changes, the guide is automatically updated. For more information, see the [doc-Contributing/README](README.md)."
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
    category_order = ['AI skills for contribution guidelines', 'AI skills for style guidelines', 'AI skills for structure', 'AI skills for file management', 'Other']

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

        # Add visible content (Overview and Examples) first
        unless skill[:visible_content].strip.empty?
          markdown << skill[:visible_content]
          markdown << ""
        end

        # Add AI-specific content (Instructions, etc.) in a collapsible section
        unless skill[:ai_content].strip.empty?
          markdown << "<details markdown=\"1\">"
          markdown << "<summary><strong>View AI tool instructions</strong></summary>"
          markdown << ""
          markdown << skill[:ai_content]
          markdown << ""
          markdown << "</details>"
          markdown << ""
        end
      end

      markdown << "---"
      markdown << ""
    end
  end

  # Add Vale rules section
  rules = read_vale_rules
  unless rules.empty?
    markdown << "# Foreman-documentation custom Vale rules"
    markdown << ""
    markdown << "The following custom Vale rules enforce documentation standards specific to Foreman."
    markdown << "Run the Vale linter locally or in CI to check AsciiDoc files against these rules."
    markdown << ""

    rules.each do |rule|
      markdown << "## #{rule[:name]}"
      markdown << ""

      # Add description if it exists
      unless rule[:description].empty?
        markdown << rule[:description]
        markdown << ""
      end

      # Embed the YAML content in a collapsible section
      markdown << "<details>"
      markdown << "<summary><strong>View rule definition</strong></summary>"
      markdown << ""
      markdown << "<pre><code class=\"language-yaml\">#{rule[:yaml]}</code></pre>"
      markdown << ""
      markdown << "</details>"
      markdown << ""
    end

    markdown << "---"
    markdown << ""
  end

  markdown.join("\n")
end

def convert_to_html(markdown_content)
  # Convert markdown to HTML using kramdown
  doc = Kramdown::Document.new(
    markdown_content,
    input: 'GFM',
    hard_wrap: false,  # Don't treat single line breaks as <br>, join into paragraphs
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
