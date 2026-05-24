#!/bin/sh

# BSD 3-Clause License
#
# Copyright (c) 2026, Spill-Tea
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Capture repository default branch name
get_default_branch() {
    git symbolic-ref refs/remotes/origin/HEAD |
        sed 's@^refs/remotes/origin/@@'
}

# Get name of current working branch
get_current_branch() {
    git rev-parse --abbrev-ref HEAD
}

# Get latest sha hash tag
get_current_sha() {
    git rev-parse --short HEAD
}

# list currently staged file names
get_staged_files() {
    git diff --cached --name-only
}

# Compute distance between two branches.
calculate_distance() {
    local branch=$1
    local ancestor=$2

    echo $(git rev-list --count "$branch..$ancestor")
}

# Identify if two branches are ancestrally linked.
is_ancestor() {
    git merge-base --is-ancestor $1 $2
}

# Confirm a branch name exists
verify() {
    git rev-parse --quiet --verify $1
}

# Confirm a branch exists within a repository
validate() {
    local branch=$1

    if [[ -z $(verify $branch) ]]; then
        printf "Aborting. Branch does not exist locally in repo: $branch\n"
        return 1
    fi
}

# list all branches (without any formatting)
list_branches() {
    git branch --format='%(refname:short)'
}

# Capture names of every branch merged to another (or default) branch
list_merged_branches() {
    local branch=${1:-$(get_default_branch)}

    if ! validate $branch; then
        return 1
    fi

    git branch --merged $branch --no-color | awk '{$1=$1};1' | grep -v $branch
}

# Capture parent branch of current branch
git_parent_branch() {
    local current=${1:-$(get_current_branch)}
    local branches=${2:-$(git for-each-ref --format='%(refname:short)' refs/heads/)}

    local best_branch=$(get_default_branch)
    local best_distance=$(calculate_distance $best_branch $current)

    local branch
    local distance
    for branch in $branches; do
        [[ $branch == "$current" ]] && continue

        if is_ancestor "$branch" "$current"; then
            distance=$(calculate_distance $branch $current)
            if ((distance < best_distance)); then
                best_distance=$distance
                best_branch=$branch
            fi
        fi
    done

    echo "$best_branch"
}

# Prune branches that have been merged to (default) branch
prune_branches() {
    local branch=${1:-$(get_default_branch)}

    if ! validate $branch; then
        return 1
    fi

    list_merged_branches $branch | xargs -n 1 git branch -d
}

# sync a current branch with its parent (default) branch
sync() {
    local default=${1:-$get_default_branch}
    local current=${2:-$(get_current_branch)}
    local branch

    # Sanity check I - confirm branches differ.
    if [ $default = $current ]; then
        printf "Aborting. Both branches specified are identical.\n"
        return 1
    fi

    # Sanity check II - confirm both branches exist.
    for branch in $default $current; do
        if ! validate $branch; then
            return 1
        fi
    done

    # Pull latest
    git checkout $default
    git pull

    # sync rebase with current working branch to maintain linear commit history.
    git checkout $current
    git rebase $default
}

# list branches with a stacked PR
get_stacked_branches() {
    local base_branch="$1"
    local branch

    if ! validate $base_branch; then
        return 1
    fi

    git for-each-ref \
        --format='%(refname:short)' \
        --merged HEAD \
        refs/heads/ |
        while read -r branch; do
            [ "$branch" = "$base_branch" ] && continue

            is_ancestor "$base_branch" "$branch" &&
                is_ancestor "$branch" HEAD &&
                echo "$branch"
        done
}

# Determine if script arguments contain "-h" or "--help" cli flags
get_help() {
    local arg
    for arg in "$@"; do
        case "$arg" in
        -h | --help)
            return 0
            ;;
        esac
    done
    return 1
}
