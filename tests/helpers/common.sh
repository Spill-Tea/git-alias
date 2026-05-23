#!/usr/bin/env bash

# confirm help menu displays correctly and conforms
# to standardized format presentation.
_assert_help_menu_standard() {
  local name=$1

  [ "$status" -eq 0 ]

  # confirm menu has all expected titles
  for k in "Usage" "Description" "Options" "Examples"; do
    [[ "$output" = *"$k:"* ]]
  done

  # help menu contains name of script
  [[ "$output" = *"$name"* ]]
}

# create new cloned git repo (with initial commits, refs, and default branch)
initialize_repo() {
  local path=$1

  local REMOTE="$path/remote.git"
  local SEED="$path/seed"
  local WORK="$path/work"

  # create bare remote
  git init --bare --initial-branch=main $REMOTE >/dev/null 2>&1

  # setup seed repo (required step to appropriately setup repo history and refs)
  mkdir -p $SEED
  cd $SEED || exit 1

  git init -q -b main >/dev/null
  git config user.name "Test User"
  git config user.email "test@example.com"
  add "project_setup" "readme.md"
  git remote add origin "$REMOTE"

  # push to remote (now remote has a main branch and an initial commit)
  push main

  # now clone remote to a working repo
  git clone "$REMOTE" "$WORK" >/dev/null 2>&1
  cd "$WORK" || exit 1
  checkout main
}

# stage a file for commit
stage() {
  local msg=$1
  local f=$2
  if [ -z $f ]; then
    f="file.txt"
  fi

  echo "$message" >> $f

  git add $f >/dev/null 2>&1
}

# commit new file
add() {
  local msg=$1

  stage $msg $2
  commit $msg
}

# delete a file from git
delete() {
  git rm $1 >/dev/null 2>&1
}

# move a file in git
move() {
  local a=$1
  local b=$2
  git mv $a $b >/dev/null 2>&1
}

# commit changes to git
commit() {
  local msg=$1
  git commit --allow-empty -qm $msg >/dev/null 2>&1
}

# create new branch
create_branch() {
  git checkout -qb $1 >/dev/null 2>&1
}

# checkout existing branch
checkout() {
  git checkout $1 >/dev/null 2>&1
}

# git pull
pull() {
  git pull >/dev/null 2>&1
}

# git push
push() {
  git push -u origin $1 >/dev/null 2>&1
}

# merge with branch
merge() {
  git merge $1 -m "$2" >/dev/null 2>&1
}

# sort variable number of args separated by new line
sort_lines() {
  printf '%s\n' "$@" | sort
}

# Compare variable args to lines captured are equivalent (useful for multiline output)
# lines and input args are sorted, such that the order is irrelevant
assert_lines_equal() {
  local i
  local count=${#lines[@]}
  local expected=($(sort_lines "$@"))
  local out=($(sort_lines "${lines[@]}"))

  if [[ "$count" -ne "${#expected[@]}" ]]; then
    echo "line count mismatch $count vs ${#expected[@]}"
    return 1
  fi

  for ((i = 0; i < $count; i++)); do
    if [[ "${out[$i]}" != "${expected[$i]}" ]]; then
      echo "line $i mismatch"
      echo "expected: [${expected[$i]}]"
      echo "actual:   [${out[$i]}]"
      return 1
    fi
  done
}

# value within an array
in_line() {
  local needle="$1"
  shift

  local j
  for j in "$@"; do
    [[ "$j" = "$needle" ]] && return 0
  done

  return 1
}

approx_in_line() {
    local needle="$1"
  shift

  local j
  for j in "$@"; do
    [[ "$j" =~ *$needle* ]] && return 0
  done

  return 1
}