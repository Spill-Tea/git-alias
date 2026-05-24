#!/usr/bin/env bats

load helpers/common.sh


NAME="git-parent.sh"
DIR="$( dirname "$BATS_TEST_DIRNAME" )/src"
SCRIPT="$DIR/$NAME"


setup() {
  source $SCRIPT

  # create mock git repo
  MOCK_REPO="$BATS_TEST_TMPDIR/repo"
  initialize_repo $MOCK_REPO

  # create and switch to a new branch name
  CURRENT_BRANCH="Axoltl"
  create_branch $CURRENT_BRANCH
  add "i is salamander"
}


teardown() {
  rm -rf $MOCK_REPO
}


@test "Confirm show_help_menu output" {
  run show_help_menu

  _assert_help_menu_standard $NAME
}


@test "Confirm $NAME -h output help menu 1" {
  run sh $SCRIPT -h

  _assert_help_menu_standard $NAME
}


@test "Confirm $NAME --help output help menu 2" {
  run sh $SCRIPT --help

  _assert_help_menu_standard $NAME
}


confirm_parent() {
  local branch=$1

  [ "$status" -eq 0 ]
  ! [ -z "$output" ]
  [[ "$output" = $branch ]]
}


@test "Confirm $NAME output" {
  run sh $SCRIPT

  confirm_parent "main"
}


@test "Confirm $NAME output after additional checkout" {
  # setup
  local new_branch="Bear"
  create_branch $new_branch
  add "i is furry monster"

  run sh $SCRIPT

  confirm_parent $CURRENT_BRANCH
}


@test "Confirm $NAME with arg output" {
  run sh $SCRIPT $CURRENT_BRANCH

  confirm_parent "main"
}


@test "Confirm $NAME with arg output after additional checkout" {
  # setup
  local new_branch="lion"
  create_branch $new_branch
  add "oh my!"

  run sh $SCRIPT $new_branch

  confirm_parent $CURRENT_BRANCH
}


@test "Confirm alias output" {
  # create git alias to script
  local name="nsfchv335s"
  alias $name $SCRIPT

  run git $name

  confirm_parent "main"
}


@test "Confirm alias output after additional checkout" {
  # setup
  local new_branch="Bear"
  create_branch $new_branch
  add "i is furry monster"

  # create git alias to script
  local name="nsfchv335s"
  alias $name $SCRIPT

  run git $name

  confirm_parent $CURRENT_BRANCH
}


@test "Confirm alias with arg output" {
  # create git alias to script
  local name="nsfchv335s"
  alias $name $SCRIPT

  run sh $SCRIPT $CURRENT_BRANCH

  confirm_parent "main"
}


@test "Confirm alias with arg output after additional checkout" {
  # create git alias to script
  local name="nsfchv335s"
  alias $name $SCRIPT

  # setup
  local new_branch="lion"
  create_branch $new_branch
  add "oh my!"

  run git $name $new_branch

  confirm_parent $CURRENT_BRANCH
}
