require 'asciidoctor/extensions'

class RobotsMetaDocinfoProcessor < Asciidoctor::Extensions::DocinfoProcessor
  use_dsl
  at_location :head

  def process(document)
    doc_state = document.attr('docstate').to_s.downcase
    project_version = document.attr('foremanversion')
    latest_stable_version = document.attr('latest-stable-version')

    return unless %w[rc stable unsupported].include?(doc_state)
    return if latest_stable_version.nil? || latest_stable_version.empty?
    return if project_version == latest_stable_version

    '<meta name="robots" content="noindex">'
  end
end

Asciidoctor::Extensions.register do
  docinfo_processor RobotsMetaDocinfoProcessor
end
