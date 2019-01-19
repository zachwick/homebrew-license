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

  opts.on("-d", "--description WANTED", "Search only descriptions") do |w|
    options[:search] += 1
    options[:search_type] = :description
    options[:wanted] = w
  end

  opts.on("-n", "--name WANTED", "Search only names") do |w|
    options[:search] += 1
    options[:search_type] = :name
    options[:wanted] = w
  end

  options
end.parse!

if options[:search] > 1
  odie too_many_flags
elsif options[:search] == 1
  if options[:search_type] == :name
    candidates = descriptions.find_all do |n, d|
      n[/#{options[:wanted]}/i]
    end
  elsif options[:search_type] == :description
    candidates = descriptions.find_all do |n, d|
      d[/#{options[:wanted]}/i]
    end
  else
    candidates = descriptions.find_all do |n, d|
      n[/#{options[:wanted]}/i] || d[/#{options[:wanted]}/i]
    end
  end

  candidates.sort! {|a,b| a[0] <=> b[0]}

  # Tty.<color> variables taken from HOMEBREW_LIBRARY_PATH/utils.rb
  candidates.each do |name, desc|
    if desc.empty?
      msg = "#{Tty.yellow}#{name}#{Tty.reset}: no description yet"
    else
      msg = "#{Tty.white}#{name}#{Tty.reset}: #{desc}"
    end

    puts msg
  end
else
  ARGV.each do |candidate|
    if descriptions.key?(candidate)
      if descriptions[candidate].empty?
        puts "#{Tty.yellow}#{candidate}#{Tty.reset}: no description yet"
      else
        puts "#{Tty.white}#{candidate}#{Tty.reset}: #{descriptions[candidate]}"
      end
    else
      opoo "#{candidate} is not a recognized formula name"
    end
  end
end

