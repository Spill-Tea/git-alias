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

show_help_menu() {
    cat <<EOF
Usage:
    bash setup.sh [options]

Description:
    Setup script git aliases, using available scripts.

Options:
    -h, --help      Show this help message and exit
    -g, --global    if true, set global aliases, otherwise only setup locally.

Examples:
    bash git-setup.sh
    bash git-setup.sh --help
    bash git-setup.sh --global

EOF
}

extract_name() {
    local filepath="$1"
    local filename

    filename="${filepath##*/}"  # remove directory path
    filename="${filename#git-}" # remove prefix
    filename="${filename%.sh}"  # remove suffix

    printf '%s\n' "$filename"
}

# create a git alias to a bash script.
# Usage:
#   alias <alias name> <path/to/script>
alias() {
    local alias_name=$1
    local path=$2
    shift 2
    git config $@ "alias.$alias_name" "!bash \"$path\""
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then
    # import common lib
    Directory="$(
        cd -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1
        pwd -P
    )"
    source "$Directory/src/lib.sh"

    if get_help "$@"; then
        show_help_menu
        exit 0
    fi

    is_global=$(has_flag "-g" "--global" $@)
    if [ $is_global ]; then
        echo "Global flag detected. Aliases will be created globally."
    fi

    for file in "$Directory/src"/*.sh; do
        base=$(basename -- $file)
        if ! [[ $base =~ "git-"* ]]; then
            continue
        fi
        name=$(extract_name $base)
        if [ $is_global ]; then
            alias $name $file --global
        else
            alias $name $file
        fi
    done
fi
