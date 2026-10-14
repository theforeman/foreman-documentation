require 'asciidoctor/extensions'

# Rewrites plain listing blocks (----) that show terminal commands so the
# prompt character is rendered through CSS instead of being part of the
# copyable text:
#
#   # hammer host list
#
# becomes
#
#   <div class="listingblock terminal">
#     <pre class="nowrap"><span class="command" data-prompt="#">hammer host list</span></pre>
#
# This runs as a postprocessor on the rendered HTML so that attribute
# substitution happens normally. Resolving block content earlier (for
# example from a tree processor) would evaluate attribute references
# against the document's end-of-parse attribute table, where attributes
# defined and unset within an included module are already gone.
class CommandPromptsPostprocessor < Asciidoctor::Extensions::Postprocessor
  LISTING_BLOCK = /(<div class="listingblock([^"]*)">)(\s*<div class="content">\s*)(<pre[^>]*>)(.*?)<\/pre>/m
  PROMPT_LINE = /\A(<code[^>]*>)?([#$]) (.*)\z/
  FIRST_PROMPT_LINE = /\A[#$] /

  def process(document, output)
    output.gsub(LISTING_BLOCK) do
      opening = $1
      roles = $2
      middle = $3
      pre_open = $4
      body = $5
      next $& if roles.include?('terminal')
      next $& if body.include?('<code')

      lines = body.split("\n", -1)
      next $& unless lines.first&.match?(FIRST_PROMPT_LINE)

      transformed = lines.map do |line|
        if (match = line.match(PROMPT_LINE))
          %(#{match[1]}<span class="command" data-prompt="#{match[2]}">#{match[3]}</span>)
        else
          line
        end
      end

      %(#{opening.sub(/">\z/, ' terminal">')}#{middle}#{pre_open}#{transformed.join("\n")}</pre>)
    end
  end
end

Asciidoctor::Extensions.register do
  postprocessor CommandPromptsPostprocessor
end
