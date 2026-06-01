# Git-Alias

a set of bash scripts to setup as git alias' to streamline
standard git workflows.

<!-- omit in toc -->
## Table of Contents
- [Git-Alias](#git-alias)
  - [Simple setup](#simple-setup)
  - [Scripts](#scripts)
    - [current](#current)
    - [default](#default)
    - [last-date](#last-date)
    - [list-merged](#list-merged)
    - [logs](#logs)
    - [parent](#parent)
    - [prune](#prune)
    - [sha](#sha)
    - [stack](#stack)
    - [staged](#staged)
    - [sync](#sync)
    - [unstage](#unstage)
    - [verify](#verify)
  - [Contributing](#contributing)
    - [Getting Started](#getting-started)
    - [Writing a new git alias script](#writing-a-new-git-alias-script)
  - [License](#license)

## Simple setup

If you want to setup all available scripts as git alias', then clone the repo and use
the `setup.sh` script to help. Adding the `--global` flag to the script sets up global
alias'. If you'd prefer to test the scripts locally, change into a different git repo
directory, and call the setup script without the `--global` flag.

```bash
git clone https://github.com/Spill-Tea/git-alias
cd git-alias
bash setup.sh --global
```

## Scripts
All available scripts map 1:1 with a git alias name following the format
`git-{alias name}.sh`. Every script (and alias) has a help menu that can be triggered
with the `-h` optional flag.

### current
report the name of the currently active branch.

### default
report the name of the repository default branch. Typically this is either `main` or
`master`, but this script makes no assumptions on what the default branch name is.

### last-date
report the author date (in iso8601 format) of the latest (i.e. most current) commit.

### list-merged
report every local branch name that has been merged to a specific branch (typically the
default branch).

### logs
write out commit logs as single formatted lines. used identically to `git log`
subparser, and can accept all additional arguments and options.

### parent
report parent branch name of current branch (or user provided branch name).

### prune
Delete all branches that have been merged to a specific branch (typically default
branch). Internally uses `list-merged` to identify all said branches.

### sha
report git sha hash of latest (i.e. most current) commit.

### stack
report all branches within a "stacked PR".

### staged
report all files that have been staged for commit.

### sync
rebase current branch to default (or parent) branch.

### unstage
unstage a specific file from commit (i.e. the antithesis to `git add`).

### verify
Confirm if a branch name exists, returning a sha hash if found.

## Contributing
### Getting Started
To get started, clone the repo with submodules, run you first test with bats, and setup
[prek](https://github.com/j178/prek) pre-commit hooks.

```bash
git clone --recurse-submodules https://github.com/Spill-Tea/git-alias
cd git-alias

# run tests locally
tests/bats/bin/bats \
    --pretty \
    --timing \
    --print-output-on-failure \
    --line-reference-format colon \
    tests/

# use prek (or pre-commit)
prek install
prek run --all-files
```
### Writing a new git alias script
Follow the conventions of the other scripts.

1. Make sure to have a help menu message that is triggered by the `-h` option flag.
1. Make sure the script file name follows the convention `git-{alias name}.sh`.
   1. keep the alias name straightforward and short.
   1. Name should not contain spaces.
   1. Prefer dashes over underscores.
   1. name should be somewhat self explanatory (e.g. having a single letter name is too
      obfuscated in meaning.)
1. The script should not be triggered if sourced (i.e. imported) from another file.
1. new scripts should be properly unit tested. Make sure to setup an appropriate mock
   git repo for consistent testing purposes that is relevant for the task being
   accomplished.
   1. make sure to test the function output directly (if the core functionality is with
      core lib), as the script, and as a git alias.
   1. If a script / function accepts optional arguments, make sure to test both implicit
      and explicit usage.

## License
[BSD-3](LICENSE)
