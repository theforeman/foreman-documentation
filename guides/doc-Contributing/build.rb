#!/usr/bin/env ruby
# Build script for Contributors' Guide
# Concatenates markdown sources and converts to AsciiDoc

require 'kramdown-asciidoc'
require 'fileutils'

# Paths
ROOT_DIR = File.expand_path('../..', __dir__)
DOC_DIR = __dir__
OUTPUT_FILE = File.join(DOC_DIR, 'topics', 'contributing-generated.adoc')

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

        # Add AI-specific content (Instructions, etc.) - will be wrapped in collapsible block
        unless skill[:ai_content].strip.empty?
          markdown << "<!-- COLLAPSIBLE_START: AI Tool Instructions -->"
          markdown << ""
          markdown << skill[:ai_content]
          markdown << ""
          markdown << "<!-- COLLAPSIBLE_END -->"
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

      # Embed the YAML content - will be wrapped in collapsible block
      markdown << "<!-- COLLAPSIBLE_START: Rule Definition -->"
      markdown << ""
      markdown << "```yaml"
      markdown << rule[:yaml].strip
      markdown << "```"
      markdown << ""
      markdown << "<!-- COLLAPSIBLE_END -->"
      markdown << ""
    end

    markdown << "---"
    markdown << ""
  end

  markdown.join("\n")
end

def convert_to_asciidoc(markdown_content)
  # Convert markdown to AsciiDoc using kramdown-asciidoc
  Kramdown::AsciiDoc.convert(markdown_content, input: 'GFM')
end

def wrap_collapsible_sections(asciidoc_content)
  # Post-process to wrap marked sections in HTML details blocks
  # Note: HTML comments get converted to AsciiDoc comments (//) by kramdown
  lines = asciidoc_content.lines
  result = []
  in_collapsible = false
  collapsible_title = nil
  collapsible_content = []

  lines.each do |line|
    # Match AsciiDoc comment syntax (kramdown converts <!-- --> to //)
    if line =~ /^\/\/\s*COLLAPSIBLE_START:\s*(.+?)$/
      in_collapsible = true
      collapsible_title = $1.strip
      collapsible_content = []
    elsif line =~ /^\/\/\s*COLLAPSIBLE_END\s*$/
      # Output HTML details block using AsciiDoc passthrough
      result << "++++\n"
      result << "<details>\n"
      result << "<summary>#{collapsible_title}</summary>\n"
      result << "<div class=\"content\">\n"
      result << "++++\n"
      result << "\n"
      result.concat(collapsible_content)
      result << "\n"
      result << "++++\n"
      result << "</div>\n"
      result << "</details>\n"
      result << "++++\n"
      result << "\n"
      in_collapsible = false
      collapsible_title = nil
      collapsible_content = []
    elsif in_collapsible
      collapsible_content << line
    else
      result << line
    end
  end

  result.join
end


# Main build process
def build
  puts "Building Contributors' Guide..."

  # Create output directory
  topics_dir = File.dirname(OUTPUT_FILE)
  FileUtils.mkdir_p(topics_dir)

  # Build markdown content
  puts "  - Concatenating markdown sources..."
  markdown_content = build_markdown

  # Convert to AsciiDoc
  puts "  - Converting to AsciiDoc..."
  asciidoc_content = convert_to_asciidoc(markdown_content)

  # Wrap collapsible sections
  puts "  - Wrapping collapsible sections..."
  asciidoc_content = wrap_collapsible_sections(asciidoc_content)

  # Write output
  puts "  - Writing to #{OUTPUT_FILE}..."
  File.write(OUTPUT_FILE, asciidoc_content)

  puts "Build complete! Output: #{OUTPUT_FILE}"
  puts "  Size: #{File.size(OUTPUT_FILE)} bytes"
end

# Run build
build
