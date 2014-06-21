# Stamper

Prepends a blurb of text to any files you specify while respecting a list of
includes and exclude patterns for maximum flexibility.

## Installation

Add this line to your application's Gemfile:

    gem 'stamper'

And then execute:

    $ bundle

Or install it yourself as:

    $ sudo gem install stamper

## Usage

### CLI

    $ stamper --help
    Usage: stamper -s STAMPFILE [options]

    Prepends a blurb of text to any files you specify while respecting
    a list of includes and exclude patterns for maximum flexibility.

    Required:
        -s, --stamp STAMPFILE            Read the stamp from the specified file.

    Options:
        -p, --path DIRECTORY             Directory to scan for files. Defaults to current directory.
        -i, --include 'REGEXP'           Only stamp files that match this pattern. Can be used multiple times.
                                         Defaults to [".*\\.rb$"].
        -e, --exclude 'REGEXP'           Do not stamp files that match this pattern. Can be used multiple times.
                                         Evaluated after includes. Defaults to ["^vendor/"].
        -r, --respect 'REGEXP'           If the first line in the file matches this pattern,
                                         place stamp under that line.
                                         Can be used multiple times. Defaults to ["^#", "^<!"].
        -d, --dry-run                    Report which files need stamping, but don't make any changes.
        -q, --quiet                      Do not print any output.
        -h, --help                       Show this message.
            --version                    Show version.

**Note**: The `--respect` option is nice for telling _Stamper_ to leave any first
magic-encoding lines untouched and unmoved. The stamp will be placed under the
matching line. Will only respect the first line, however, if matched.

**Hint**: You may want to try a few runs with the `--dry-run` option on to see what its doing,
until you get all the options you want right.

### Programmatic

    require 'stamper'

    Stamper.stamp(
      stamp: IO.read('copyright.txt'),
      files: Stamper::DEFAULTS[:files], # This is a glob. Will be fed into Dir.glob()
      includes: Stamper::DEFAULTS[:includes], # Defaults to ['.*\.rb$']
      excludes: Stamper::DEFAULTS[:excludes], # Defaults to ['^vendor/']
      respect_first_marks: Stamper::DEFAULTS[:respect_first_marks], # Defaults to ['^#', '^<!'']
      dryrun: false,
      quiet: true
    )

## Contributing

1. Fork it ( https://github.com/renier/stamper/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
