#!/usr/bin/env ruby
require 'colorize'
require 'stamper/version'

module Stamper
  DEFAULTS = {
    files: '**/*',
    includes: ['.*\.rb$'],
    excludes: ['^vendor/'],
    respect_first_marks: ['^#', '^<!'],
    dryrun: false,
    quiet: false
  }

  def self.stamp(opts)
    opts = DEFAULTS.merge(opts)

    stamp = opts[:stamp]
    files = opts[:files].is_a?(Array) ? opts[:files] : Dir.glob(opts[:files])
    includes = opts[:includes].map { |i| Regexp.new(i) }
    excludes = opts[:excludes].map { |e| Regexp.new(e) }
    respect_first_marks = opts[:respect_first_marks].map { |m| Regexp.new(m) }
    dryrun = opts[:dryrun]
    quiet = opts[:quiet]

    if dryrun
      puts "Checking files that need stamping...\n\n" unless quiet
    else
      puts "Stamping files...\n\n" unless quiet
    end

    stamped = 0
    # For each file that matches pattern(s)
    files.each do |file|
      next unless includes.any? { |include| include.match(file) }
      next if excludes.any? { |exclude| exclude.match(file) }

      # Check the header of the file. Match on first lines or shifted by one line.
      # If match, do nothing, else stamp file (or report only -- use colorize).
      contents = IO.read(file)
      next if contents.size < 1
      next if contents.start_with?(stamp)
      contents = contents.split("\n")
      next if contents[1..-1].join("\n").start_with?(stamp)

      if dryrun
        puts file unless quiet
        stamped += 1
        next
      end

      if respect_first_marks.any? { |mark| mark.match(contents.first) }
        shifted = contents.shift
        contents = shifted + "\n" + stamp + contents.join("\n")
      else
        contents = stamp + contents.join("\n")
      end

      # Make sure files have a new line at the end of the file
      contents += "\n" if contents[-1] != "\n"

      IO.write(file, contents)
      stamped += 1
      puts file unless quiet
    end

    print "\nFinished. ".green
    if dryrun
      puts "#{stamped} files need stamping.".send(stamped > 0 ? :red : :green) unless quiet
    else
      puts "#{stamped} files were stamped.".green unless quiet
    end

    dryrun && stamped > 0 ? false : true
  end
end
