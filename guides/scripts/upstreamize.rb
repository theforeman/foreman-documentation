#!/usr/bin/env ruby
require 'tempfile'
require 'fileutils'

DRY_RUN = ENV['DRY_RUN'] || false
VERBOSE = ENV['VERBOSE'] || false

def putsv(str)
  return unless VERBOSE
  puts(str)
end

File.open('upstreamize_report.md', 'w') do |report|
report.write("# Upstreamization report from #{Time.now.utc}\n")
  ARGV.each do |input_file|
    begin
      report.write("\n## #{input_file}\n")
      report.write("| Line | Contents |\n")
      report.write("| --- | --- |\n")
      temp_file = Tempfile.new($PROGRAM_NAME)
      File.open(temp_file, 'w') do |output|
        putsv "#{input_file}:"
        File.foreach(input_file).with_index do |orig_line, line_num|
          line = orig_line.dup
          if line =~ /^\[\[/
            output.write(line)
            next
          end
          line.gsub!(%r{https?://access.redhat.com/documentation/en-us/red_hat_satellite/\d\.\d/html/}, '{BaseURL}')
          line.gsub!(%r{https?://access.redhat.com/documentation/en-us/red_hat_satellite/{ProductVersion}/html/}, '{BaseURL}')
          line.gsub!(/Red( |\u{00A0}|{nbsp}) Hat Satellite( |\u{00A0}|{nbsp})6.\d/, '{ProjectNameXY}')
          line.gsub!(/Red( |\u{00A0}|{nbsp})Hat Satellite( |\u{00A0}|{nbsp})6/, '{ProjectNameX}')
          line.gsub!(/Red( |\u{00A0}|{nbsp})Hat Satellite/, '{ProjectName}')
          line.gsub!(/Red_Hat_Satellite/, '{Project_Link}')
          line.gsub!(/Satellite( |\u{00A0}|{nbsp})6.\d/, '{ProjectXY}')
          line.gsub!(/Satellite( |\u{00A0}|{nbsp})6/, '{ProjectX}')
          line.gsub!(/Satellite( |\u{00A0}|{nbsp})Server/, '{ProjectServer}')
          line.gsub!(/Satellite/, '{Project}')
          line.gsub!(/Capsule( |\u{00A0}|{nbsp})Server/, '{SmartProxyServer}')
          line.gsub!(/Capsules/, '{SmartProxies}')
          line.gsub!(/Capsule/, '{SmartProxy}')
          line.gsub!(/satellite\.example\.com/, '{foreman-example-com}')
          line.gsub!(/capsule\.example\.com/, '{smartproxy-example-com}')
          line.gsub!(/satellite-installer --scenario satellite/, '{installer-scenario}')
          line.gsub!(/satellite-installer --scenario capsule/, '{installer-scenario-smartproxy}')
          line.gsub!(/satellite-installer/, '{foreman-installer}')
          line.gsub!(/capsule-certs-generate/, '{certs-generate}')
          line.gsub!(/an IdM/, 'a {FreeIPA}')
          line.gsub!(/IdM/, '{FreeIPA}')
          line.gsub!(/satellite-maintain packages install/, '{package-install-project}')
          line.gsub!(/satellite-maintain packages remove/, '{package-remove-project}')
          line.gsub!(/satellite-maintain/, '{foreman-maintain}')
          if match = line.match(/^\[options="(\w+)",? subs="(.*)"\]/)
            first, second = match.captures
            line = "[options=\"#{first}\", subs=\"#{second},attributes\"]\n" unless second =~ /attributes/
          end
          if line != orig_line
            putsv("#{line_num + 1}: #{line}")
            report.write("| #{line_num + 1} | `#{line.chomp.tr('|`', '_\'')}` |\n")
          end
          output.write(line)
        end
      end
      FileUtils.mv(temp_file, input_file) unless DRY_RUN
    rescue StandardError => e
      puts "Error processing #{input_file}: #{e}"
    ensure
      FileUtils.rm(temp_file.path) if File.exist?(temp_file.path)
    end
  end
end
