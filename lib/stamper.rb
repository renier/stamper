#!/usr/bin/env ruby
require 'colorize'
require 'stamper/version'

module Stamper
  DEFAULTS = {
    files: '**/*',
    includes: ['.*\.rb$'],
    excludes: ['/vendor/'],
    respect_first_marks: ['^#', '^<!'],
    dryrun: false
  }

  def self.stamp(opts)
    opts = DEFAULTS.merge(opts)

    stamp, files = opts[:stamp], Dir.glob(opts[:files])
    includes, excludes = opts[:includes], opts[:excludes]
    respect_first_marks, dryrun = opts[:respect_first_marks], opts[:dryrun]
    log = opts[:log]

    if dryrun
      log.info "Checking files that need stamping...\n\n" unless log.nil?
    else
      log.info "Stamping files...\n\n" unless log.nil?
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

      if dryrun
        log.info file unless log.nil?
        stamped += 1
        next
      end

      if respect_first_marks.any? { |mark| Regexp.new(mark).match(contents.first) }
        shifted = contents.shift
        contents = shifted + "\n" + stamp + contents.join("\n")
      else
        contents = stamp + contents.join("\n")
      end

      IO.write(file, contents)
      stamped += 1
      log.info file unless log.nil?
    end

    print "\nFinished. ".green
    if dryrun
      log.info "#{stamped} files need stamping.".send(stamped > 0 ? :red : :green) unless log.nil?
    else
      log.info "#{stamped} files were stamped.".green unless log.nil?
    end

    dryrun && stampled > 0 ? false : true
  end
end
