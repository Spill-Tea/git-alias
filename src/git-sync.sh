#!/bin/sh

# BSD 3-Clause License

# Copyright (c) 2026, Spill-Tea

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:

# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.

# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.

# 3. Neither the name of the copyright holder nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.

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

# git-sync.sh
#
# Sync the current working branch with the primary default branch.
# If no arguments are provided, these default to the current branch you are actively in
# and the default branch of the repository.
#
# Example:
#
# ```sh
# sh git-sync.sh {default_branch} {current_branch}
#
# ```
#

set -e

# Arguments, with defaults
DEFAULT_BRANCH=${1:-$(git default)}
CURRENT_BRANCH=${2:-$(git current)}

# Sanity checks - confirm both branches exist before proceeding.
if [ $DEFAULT_BRANCH = $CURRENT_BRANCH ]; then
    printf "Aborting. Both branches specified are identical.\n"
    exit 1
fi

for branch in $DEFAULT_BRANCH $CURRENT_BRANCH
do
    if [[ -z `git verify $branch` ]]; then
        printf "Aborting. Branch does not exist locally in repo: $branch\n"
        exit 1
    fi
done

# Pull latest
git checkout $DEFAULT_BRANCH
git pull

# sync rebase with current working branch to maintain linear commit history.
git checkout $CURRENT_BRANCH
git rebase $DEFAULT_BRANCH
