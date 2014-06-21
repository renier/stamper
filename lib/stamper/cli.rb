require 'optparse'
require 'ostruct'
require 'stamper'

module Stamper
  def self.CLI(args)
    options = OpenStruct.new

    optparse = OptionParser.new do |opts|
      opts.banner = 'Usage: stamper -s STAMPFILE [options]'
      opts.separator ''
      opts.separator 'Prepends a blurb of text to any files you specify while respecting'\
                     ' a list of includes and exclude patterns for maximum flexibility.'
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
      ) do |include|
        options.excludes ||= []
        options.excludes << excludes
      end

      opts.on(
        '-d',
        '--dry-run',
        'Report which files need stamping, but don\'t make any changes.'
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

    optparse.parse!

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
      dryrun: options.dryrun,
      respect_first_marks: options.marks ? options.marks : Stamper::DEFAULTS[:respect_first_marks],
      log: Logger.new(STDOUT)
    )
  end
end
