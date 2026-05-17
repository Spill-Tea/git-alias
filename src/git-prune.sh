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

# git-prune.sh
#
# Prune stale local branches that have been merged upstream to a specific branch. If no
# branch is specified, the default repository branch is assumed. This behavior can be
# modified using the `GIT_FLOW_BRANCH` environment variable, which is helpful when
# using a git flow model, where the primary development branch is not the default
# branch.
#
# Example:
#
# ```sh
# sh git-prune.sh {default_branch}
#
# ```
#

BRANCH=$1

if [[ -z $BRANCH ]]; then
    BRANCH="${GIT_FLOW_BRANCH}"
    if [[ -z $BRANCH ]]; then
        BRANCH=$(git default)
    fi
fi

# Sanity check
if [[ -z `git verify $BRANCH` ]]; then
    printf "Aborting. Branch does not exist locally in repo: $BRANCH\n"
    exit 1
fi

git list-merged $BRANCH | xargs -n 1 git branch -d
