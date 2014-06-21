#!/usr/bin/env ruby
require 'colorize'

module Stamper
  def self.stamp(stamp, files = [], includes = [], excludes = [], checkonly = false)
    if checkonly
      puts "Checking files that need stamping...\n\n"
    else
      puts "Stamping files...\n\n"
    end

    stamped = 0
    # For each file that matches pattern(s)
    files.each do |file|
      next unless includes.any? { |include| Regexp.new(include).match(file) }
      next if excludes.any? { |exclude| Regexp.new(exclude).match(file) }

      # Check the header of the file. Match on first lines or shifted by one line.
      # If match, do nothing, else stamp file (or report only -- use colorize).
      contents = IO.read(file)
      next if contents.size < 1
      next if contents.start_with?(stamp)
      contents = contents.split("\n")
      next if contents[1..-1].join("\n").start_with?(stamp)

      if checkonly
        puts file
        stamped += 1
        next
      end

      # TODO: have a list of recognized file headers
      if contents[0].start_with?('#') || contents[0].start_with?('<!')
        shifted = contents.shift
        contents = shifted + "\n" + stamp + contents.join("\n")
      else
        contents = stamp + contents.join("\n")
      end

      IO.write(file, contents)
      stamped += 1
      puts file
    end

    print "\nFinished. ".green
    if checkonly
      puts "#{stamped} files need stamping.".send(stamped > 0 ? :red : :green)
    else
      puts "#{stamped} files were stamped.".green
    end

    checkonly && stampled > 0 ? false : true
  end
end
