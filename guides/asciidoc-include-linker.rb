#!/usr/bin/env ruby
require "find"
require "fileutils"

DIR=ARGV[1] || '.'
ALDIR="#{DIR}/.alink"
FileUtils.rm_rf(ALDIR)
 
Find.find(DIR) do |file|
  next if file.match(/^.\/(.git|.alink)/)
  next unless file.match(/\.adoc\Z/)
  dirname = File.dirname(file)
  basename = File.basename(file)
  counter = 0
  File.open(file, "r").each_line do |line|
    match = line.match(/include::(.*)\[/)
    if match
      target_string = match.captures.first
      target_real = "#{dirname}/#{target_string}"
      if File.exist?(target_real)
        n = sprintf("%03d", counter)
        link = "#{ALDIR}/#{dirname}/#{n}-#{basename}-#{target_string.tr('/', '_')}"
        target = File.absolute_path(target_real)
        counter += 1
        #puts "#{link} -> #{target}"
        FileUtils.mkdir_p(File.dirname(link))
        FileUtils.ln_sf(target, link)
      else
        puts "Ignoring missing #{ref}"
      end
    end
  end
end