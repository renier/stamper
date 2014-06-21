require 'optparse'
require 'ostruct'
require 'logger'
require 'stamper'

module Stamper
  def self.CLI(args) # rubocop:disable MethodName
    options = OpenStruct.new

    optparse = OptionParser.new do |opts|
      opts.banner = 'Usage: stamper -s STAMPFILE [options]'
      opts.separator ''
      opts.separator "Prepends a blurb of text to any files you specify while respecting\n"\
                     'a list of includes and exclude patterns for maximum flexibility.'
      opts.separator ''

      opts.separator 'Required:'
      opts.on('-s', '--stamp STAMPFILE', 'Read the stamp from the specified file.') do |stamp|
        options.stamp = stamp
      end

      opts.separator ''
      opts.separator 'Options:'

      opts.on(
        '-p',
        '--path DIRECTORY',
        'Directory to scan for files. Defaults to current directory.'
      ) do |path|
        options.path = path
      end

      opts.on(
        '-i',
        '--include \'REGEXP\'',
        "Only stamp files that match this pattern. Can be used multiple times.\n"\
        "\t\t\t\t\tDefaults to #{Stamper::DEFAULTS[:includes]}."
      ) do |include|
        options.includes ||= []
        options.includes << include
      end

      opts.on(
        '-e',
        '--exclude \'REGEXP\'',
        "Do not stamp files that match this pattern. Can be used multiple times.\n"\
        "\t\t\t\t\tEvaluated after includes. Defaults to #{Stamper::DEFAULTS[:excludes]}."
      ) do |exclude|
        options.excludes ||= []
        options.excludes << exclude
      end

      opts.on(
        '-r',
        '--respect \'REGEXP\'',
        "If the first line in the file matches this pattern,\n"\
        "\t\t\t\t\tplace stamp under that line. \n"\
        "\t\t\t\t\tCan be used multiple times. Defaults to #{Stamper::DEFAULTS[:respect_first_marks]}."
      ) do |mark|
        options.marks ||= []
        options.marks << mark
      end

      opts.on(
        '-d',
        '--dry-run',
        'Report which files need stamping, but don\'t make any changes.'
      ) do |dryrun|
        options.dryrun = dryrun
      end

      opts.on(
        '-q',
        '--quiet',
        'Do not print any output.'
      ) do |dryrun|
        options.dryrun = dryrun
      end

      opts.on_tail('-h', '--help', 'Show this message.') do
        puts opts
        exit
      end

      opts.on_tail('--version', 'Show version.') do
        puts VERSION
        exit
      end
    end

    optparse.parse!(args)

    if options.stamp.nil?
      puts "No stamp file specified.\n\n"
      puts optparse
      exit
    end

    Stamper.stamp(
      stamp: IO.read(options.stamp),
      files: options.path ? options.path + '/**/*' : Stamper::DEFAULTS[:files],
      includes: options.includes ? options.includes : Stamper::DEFAULTS[:includes],
      excludes: options.excludes ? options.excludes : Stamper::DEFAULTS[:excludes],
      respect_first_marks: options.marks ? options.marks : Stamper::DEFAULTS[:respect_first_marks],
      dryrun: options.dryrun,
      quiet: options.quiet
    )
  end
end
