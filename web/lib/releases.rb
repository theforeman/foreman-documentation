require 'bundler'
require 'json'

class ReleaseDataSource < ::Nanoc::DataSource
  identifier :releases

  def content_dir_name
    'releases'
  end

  def versions
    Dir[File.join(content_dir_name, '*.json')].map do |filename|
      [File.basename(filename, '.json'), filename]
    end.sort_by! do
      |version, _| Gem::Version.new(version == 'nightly' ? '9999' : version)
    end.reverse!
  end

  def items
    versions.flat_map do |version, filename|
      release = JSON.parse(File.read(filename))
      release['foreman'] = version
      release['state'] ||= 'unsupported'
      release['title'] = release_menu_title(release)

      context = {
        title: "Foreman #{version} - Katello #{release['katello']}",
        version: version,
        state: release['state'],
        katello: release['katello'],
        release: release,
        builds: release['builds'],
      }

      [
        new_item(
          File.read(File.join(content_dir_name, 'release.adoc.erb')),
          context,
          "/#{version}/index.adoc.erb",
        )
      ] + release['builds'].map do |build|
        context = build.merge(
          'foreman' => version,
          'katello' => release['katello'],
          'other_builds' => [],
        )

        new_item(
          File.read(File.join(content_dir_name, 'release-build.adoc.erb')),
          context,
          "/#{version}/#{File.basename(build['filename'], '.html')}.adoc.erb",
        )
      end
    end
  end

  def item_changes
    changes_for_dir(content_dir_name)
  end

  def changes_for_dir(dir)
    require 'listen'

    Nanoc::Core::ChangesStream.new do |cl|
      listener =
        Listen.to(dir) do |_modifieds, _addeds, _deleteds|
          cl.unknown
        end

      listener.start

      cl.to_stop { listener.stop }

      sleep
    end
  end
end

def release_menu_title(release)
  return 'nightly' if release['path'] == 'nightly'

  "Foreman #{release['foreman']} - Katello #{release['katello']} (#{release['state']})"
end

def releases
  @items.find_all('/release/*/index.adoc.erb')
end

def releases_in_state(state)
  releases.filter { |release| release[:state] == state }
end
