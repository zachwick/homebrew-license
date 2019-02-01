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

# Configure RubyGems.
REPO_ROOT = Pathname.new "#{File.dirname(__FILE__)}/.."
VENDOR_RUBY = "#{REPO_ROOT}/vendor/ruby".freeze
BUNDLER_SETUP = Pathname.new "#{VENDOR_RUBY}/bundler/setup.rb"
unless BUNDLER_SETUP.exist?
  Homebrew.install_gem_setup_path! "bundler"

  REPO_ROOT.cd do
    safe_system "bundle", "install", "--standalone", "--path", "vendor/ruby"
  end
end
require "rbconfig"
ENV["GEM_HOME"] = ENV["GEM_PATH"] = "#{VENDOR_RUBY}/#{RUBY_ENGINE}/#{RbConfig::CONFIG["ruby_version"]}"
Gem.clear_paths
Gem::Specification.reset
require_relative BUNDLER_SETUP

require 'formula'
require 'optparse'
require 'json'
require 'octokit'
require_relative '../lib/formula_loader'

# use only SPDX identifiers -> https://spdx.org/licenses/
# except when a package's license does not have an SPDX identifier
file = File.expand_path File.dirname(__FILE__) + '/licenses.json'
licenses = JSON.parse IO.read file

usage = <<EOS
SYNOPSIS

brew licence formula1
brew license formula1 formula2 ...
brew licence [-r|--recurse] formula1
brew license [-f|--fetch] formula1
brew license [-h|--help]

USAGE

Fetch and print the license(s) that the given formula is licensed under. Using `-r` will recurse through the dependency tree printing out `formulaX: License1` pairs.

FLAGS

    -r, --recurse          Recurse through the dependency tree and invoke `brew license <formula>` for each dependency
    -f, --fetch            Attempt to fetch license information for the given formula via the Github License API
    -h, --help             Show this help message

EXAMPLES

    brew license erlang python3     # Show licensing information for these items
    brew license -r erlang          # Show licensing information for all formulae in the dependency tree of this item
    brew licence -f adplug          # Attempt to fetch licensing information for this formula from Github Licenses API
EOS

show_usage = <<EOS
#{usage}
EOS

options = {}
OptionParser.new do |opts|
  options[:search] = 0

  opts.on('-h', '--help', 'Display this help message') do
    puts usage
    exit
  end

  opts.on('-r', '--recurse', 'Recurse through all dependencies of the given formula') do |r|
    options[:search] += 1
    options[:recurse] = true
  end

  opts.on('-f', '--fetch', 'Attempt to fetch license information for the given formula via the Github License API') do |r|
    options[:search] += 1
    options[:github] = true
    options[:recurse] = false
  end

  options
end.parse!

if options[:search] > 1
  odie too_many_flags
  exit
elsif  options[:search] == 1
  candidates = []
  ARGV.each do |candidate|
    candidates += Homebrew::FormulaLoader.load_formulas(candidate, options[:recurse])
  end
else
  candidates = []
  ARGV.each do |candidate|
    candidates += [{name: candidate, homepage: ''}]
  end
end

candidates.each do |candidate|
  if options[:github]
    # Attempt to fetch license info from Github Licenses API
    # 1. Is the project's homepage is something github.com or github.io?
    # 2. If it is, attempt to use the Licenses API
    # puts("#{candidate[:name]}: #{candidate[:homepage]}")
    homepage = candidate[:homepage]
    if homepage.include? 'github.com'
      hp_parts = homepage.split('/')

      github_client = Octokit::Client.new()

      license = github_client.repository_license_contents "#{hp_parts[hp_parts.length - 2]}/#{hp_parts[hp_parts.length - 1]}", :accept => 'application/vnd.github.json'
      puts "#{candidate[:name]}: \"#{license['license']['spdx_id']}\""
    else
      puts "#{candidate[:name]}'s homepage is not a Github repo so we can't fetch license info.\nVisit #{candidate[:homepage]} to find licensing info."
    end
  else
    if licenses.key?(candidate[:name])
      if licenses[candidate[:name]].empty?
        puts "#{candidate[:name]}: no licensing info yet"
      else
        puts "#{candidate[:name]}: #{licenses[candidate[:name]]}"
      end
    else
      opoo "#{candidate[:name]} is not a recognized formula name"
    end
  end
end
