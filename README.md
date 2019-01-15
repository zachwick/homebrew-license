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
brew livecheck
brew livecheck formula1 formula2 ...
brew livecheck [-r|--recurse]
brew livecheck [-h|--help]

Usage:
Fetch and print the license(s) that the given formula is licensed under. Using `-r` will recurse through the dependency tree printing out `formulaX: License1` pairs.

Options:
-h, --help        show this help message and exit
-r, --recurse     recurse through the dependency tree and invoke `brew license <formula>` for each dependency
```

## Contributions are welcomed
If you like this project and you find it useful, help me by adding more Livecheckables or by improving the code (or the non-existing wiki, the readme, etc.).

## Changelog
See the git log.













