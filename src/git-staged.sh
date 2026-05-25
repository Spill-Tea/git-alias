#!/usr/bin/env bash

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

# git-staged.sh
#
# Retrieve the names of every file staged (i.e. git add / rm / mv) for commit
#
# Example:
#
# ```sh
# bash git-staged.sh
#
# ```
#

show_help_menu() {
    cat <<EOF
Usage:
    bash git-staged.sh [options]

Description:
    Retrieve the names of every file staged (i.e. git add / rm / mv) for commit.

Options:
    -h, --help      Show this help message and exit

Examples:
    bash git-staged.sh
    sh git-verify.sh --help

EOF
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then
    # import common lib
    Directory="$(
        cd -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
        pwd -P
    )"
    source "$Directory/lib.sh"

    if get_help "$@"; then
        show_help_menu
        exit 0
    fi

    get_staged_files
fi
