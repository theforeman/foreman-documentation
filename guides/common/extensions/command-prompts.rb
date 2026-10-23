require 'asciidoctor/extensions'

class CommandPromptsTreeProcessor < Asciidoctor::Extensions::TreeProcessor
  def process(document)
    document.find_by(context: :listing) do |block|
      first_line = block.lines.first
      block.style == 'listing' && first_line && first_line.match?(/\A[#$] /)
    end.each do |block|
      attributes = block.attributes
      attributes['role'] = [attributes['role'], 'terminal'].compact.join(' ')

      lines = block.content.split("\n").map do |line|
        if line.start_with?('# ', '$ ')
          prompt = line[0]
          %(<span class="command" data-prompt="#{prompt}">#{line[2..-1]}</span>)
        else
          line
        end
      end

      siblings = block.parent.blocks
      siblings[siblings.index(block)] = create_listing_block(block.parent, lines.join("\n"), attributes, subs: nil)
    end
  end
end

Asciidoctor::Extensions.register do
  tree_processor CommandPromptsTreeProcessor
end
