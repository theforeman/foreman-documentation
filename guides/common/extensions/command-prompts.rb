require 'asciidoctor/extensions'

# Rewrites listing blocks that show terminal commands so the prompt
# character is rendered through CSS (see .listingblock.terminal in
# _asciidoc.scss) instead of being part of the copyable text:
#
#   [role="terminal"]
#   ----
#   # hammer host list
#   ----
#
# becomes
#
#   <div class="listingblock terminal">
#     <pre class="nowrap"><span class="command" data-prompt="#">hammer host list</span></pre>
#
# Blocks marked with the terminal role are always transformed. Unmarked
# blocks are transformed when they look like terminal output (their first
# line starts with a "# " or "$ " prompt), which keeps existing content
# working until it is annotated.
#
# This runs as a postprocessor on the rendered HTML so that attribute
# substitution happens normally. Resolving block content earlier (for
# example from a tree processor) would evaluate attribute references
# against the document's end-of-parse attribute table, where attributes
# defined and unset within an included module are already gone.
class CommandPromptsPostprocessor < Asciidoctor::Extensions::Postprocessor
  # A listingblock div, an optional title div, the content div and the
  # opening <pre> tag, then the body up to the closing </pre>.
  LISTING_BLOCK = /(<div class="listingblock([^"]*)">)(\s*(?:<div class="title">.*?<\/div>\s*)?<div class="content">\s*)(<pre[^>]*>)(.*?)<\/pre>/m
  PROMPT_LINE = /\A(<code[^>]*>)?([#$]) (.*)\z/
  FIRST_PROMPT_LINE = /\A[#$] /

  def process(document, output)
    output.gsub(LISTING_BLOCK) do
      opening = $1
      roles = $2
      middle = $3
      pre_open = $4
      body = $5
      marked = roles.split.include?('terminal')
      next $& if body.include?('data-prompt')
      next $& if !marked && body.include?('<code')

      lines = body.split("\n", -1)
      next $& if !marked && !lines.first&.match?(FIRST_PROMPT_LINE)

      transformed = lines.map do |line|
        if (match = line.match(PROMPT_LINE))
          %(#{match[1]}<span class="command" data-prompt="#{match[2]}">#{match[3]}</span>)
        else
          line
        end
      end

      %(#{marked ? opening : opening.sub(/">\z/, ' terminal">')}#{middle}#{pre_open}#{transformed.join("\n")}</pre>)
    end
  end
end

Asciidoctor::Extensions.register do
  postprocessor CommandPromptsPostprocessor
end
