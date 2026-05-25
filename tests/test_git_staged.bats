#!/usr/bin/env bats

load helpers/common.sh


NAME="git-staged.sh"
DIR="$( dirname "$BATS_TEST_DIRNAME" )/src"
SCRIPT="$DIR/$NAME"


setup() {
  # create mock git repo
  MOCK_REPO="$BATS_TEST_TMPDIR/repo"
  initialize_repo $MOCK_REPO

  # create and switch to a new branch name
  CURRENT_BRANCH="busy_beaver"
  create_branch $CURRENT_BRANCH

  FILE_NAME="beaver.txt"
  stage "must_chew_tree" $FILE_NAME
}


teardown() {
  rm -rf $MOCK_REPO
}


@test "Confirm show_help_menu output" {
  source $SCRIPT

  run show_help_menu

  _assert_help_menu_standard $NAME
}


@test "Confirm $NAME -h output help menu 1" {
  run bash $SCRIPT -h

  _assert_help_menu_standard $NAME
}


@test "Confirm $NAME --help output help menu 2" {
  run bash $SCRIPT --help

  _assert_help_menu_standard $NAME
}


confirm_staged() {
  [ "$status" -eq 0 ]
  ! [ -z "$output" ]
  assert_lines_equal "$@"
}


@test "Confirm $NAME output" {
  run bash $SCRIPT

  confirm_staged $FILE_NAME
}


@test "Confirm $NAME output after git mv" {
  local readme="readme.md"
  local out="readmenot.md"
  move $readme $out

  run bash $SCRIPT

  confirm_staged $FILE_NAME $out
}


@test "Confirm $NAME output after git rm" {
  local readme="readme.md"
  delete $readme

  run bash $SCRIPT

  confirm_staged $FILE_NAME $readme
}


@test "Confirm lib fn output" {
  source "$DIR/lib.sh"

  run get_staged_files

  confirm_staged $FILE_NAME
}


@test "Confirm lib fn output after git mv" {
  source "$DIR/lib.sh"

  local readme="readme.md"
  local out="readmenot.md"
  move $readme $out

  run get_staged_files

  confirm_staged $FILE_NAME $out
}


@test "Confirm lib output after git rm" {
  source "$DIR/lib.sh"

  local readme="readme.md"
  delete $readme

  run get_staged_files

  confirm_staged $FILE_NAME $readme
}


@test "Confirm alias output" {
  # create git alias to script
  local name="ks882lw"
  alias $name $SCRIPT

  run git $name

  confirm_staged $FILE_NAME
}


@test "Confirm alias output after git mv" {
  # create git alias to script
  local name="ks882lw"
  alias $name $SCRIPT

  local readme="readme.md"
  local out="readmenot.md"
  move $readme $out

  run git $name

  confirm_staged $FILE_NAME $out
}


@test "Confirm alias output after git rm" {
  # create git alias to script
  local name="ks882lw"
  alias $name $SCRIPT

  # remove file from git repo
  local readme="readme.md"
  delete $readme

  run git $name

  confirm_staged $FILE_NAME $readme
}
