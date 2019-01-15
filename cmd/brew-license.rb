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

puts "LICENSE INFO HERE"

