#:  * `license`
#:  Display licensing information for given formulae
#:
#:  `brew license <formula1>`
#:  `brew license` <formula1> <formula2> <...>
#:  `brew license` [`-r`|`--recurse`] <formula1>
#:  `brew license` [`-h`|`--help`]
#:
#:  Usage:
#:  Fetch and print the license(s) that the given formula is licensed under.
#:  Using `-r` will recurse through the dependency tree printing out
#:  `formulaX: License1` pairs.
#:
#:  Options:
#:  `-h`, `--help`        show this help message and exit
#:  `-n`, `--newer-only`  show the latest version only if it's newer than the formula
#:  `-v`, `--verbose`     be more verbose :)
#:  `-q`, `--quieter`     be more quiet (do not show errors)
#:  `-d`, `--debug`       show debugging info

require "formula"
require "optparse"

licenses = {
  "a2ps" => "Any-to-PostScript filter",
}

usage = <<EOS
SYNOPSIS

brew licence formula1
brew license formula1 formula2 ...
brew licence [-r|--recurse] formula1
brew license [-h|--help]

USAGE

Fetch and print the license(s) that the given formula is licensed under. Using `-r` will recurse through the dependency tree printing out `formulaX: License1` pairs.

FLAGS

    -r, --recurse          Recurse through the dependency tree and invoke `brew license <formula>` for each dependency
    -h, --help             Show this help message

EXAMPLES

    brew license erlang python3     # Show licensing information for these items
    brew license -r erlang          # Show licensing information for all formulae in the dependency tree of this item
EOS

show_usage = <<EOS
#{usage}
EOS

options = {}
OptionParser.new do |opts|
  options[:search] = 0

  opts.on("-h", "--help", "Display this help message") do
    puts usage
    exit
  end

  opts.on("-r", "--recurse", "Recurse through all dependencies of the given formula") do |r|
    options[:search] += 1
    options[:base] = r
  end
  options
end.parse!

if options[:search] > 1
  odie too_many_flags
elsif  options[:search] == 1
  puts "recurse from #{options[:base]}"
  exit
else
  ARGV.each do |candidate|
    if licenses.key?(candidate)
      if licenses[candidate].empty?
        puts "#{candidate}: no licensing info yet"
      else
        puts "#{candidate}: #{licenses[candidate]}"
      end
    else
      opoo "#{candidate} is not a recognized formula name"
    end
  end
end
