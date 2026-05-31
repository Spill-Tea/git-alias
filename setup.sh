#!/usr/bin/env bash

extract_name() {
    local filepath="$1"
    local filename

    filename="${filepath##*/}"   # remove directory path
    filename="${filename#git-}"  # remove prefix
    filename="${filename%.sh}"   # remove suffix

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
