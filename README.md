homebrew-license
================
External command for showing the license(s) the given formulae are available under.

# Install
    brew tap zachwick/license

# Usage
The most useful way to use the command is by invoking

    $ brew licence formula1

which will print out any known licensing info for that formula.

```
brew licence formula1
brew license formula1 formula2 ...
brew licence [-r|--recurse] formula1
brew license [-h|--help]

Usage:
Fetch and print the license(s) that the given formula is licensed under. Using `-r` will recurse through the dependency tree printing out `formulaX: License1` pairs.

Options:
-h, --help        show this help message and exit
-r, --recurse     recurse through the dependency tree and invoke `brew license <formula>` for each dependency
```

## Contributing
Contributors to this project must read and abide by the [Homebrew Code of Conduct](https://github.com/Homebrew/brew/blob/master/CODE_OF_CONDUCT.md#code-of-conduct).

If you like this project and you find it useful, help us by adding more licensing information or by improving the code (or the non-existing wiki, the readme, etc.).

We're especially open to contributions from people who are beginners to free and open-source software, and will gladly help you get your contributions merged.

## Changelog
See the git log.













