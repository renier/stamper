require 'optparse'
require 'ostruct'
require 'stamper'

module Stamper
  def self.CLI(args)
    options = OpenStruct.new
    options.includes = []
    options.excludes = []

    optparse = OptionParser.new do |opts|
      opts.banner = 'Usage: stamper -s STAMPFILE [options]'
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
        "\t\t\t\t\tDefaults to only *.rb files."
      ) do |include|
        options.includes << include
      end

      opts.on(
        '-e',
        '--exclude \'REGEXP\'',
        "Do not stamp files that match this pattern. Can be used multiple times.\n"\
        "\t\t\t\t\tEvaluated after includes. Defaults to '/vendor/'."
      ) do |include|
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
      puts 'No stamp file specified.'
      puts optparse
      exit
    end

    Stamper.stamp(
      IO.read(options.stamp),
      options.path ? Dir.glob(options.path + '/**/*') : Dir.glob('**/*'),
      options.includes.empty? ? ['.*\.rb$'] : options.includes,
      options.excludes.empty? ? ['/vendor/'], options.excludes
      options.dryrun,
      Logger.new(STDOUT),
      options.marks ? options.marks : ['^#', '^<!']
    )
  end
end
