#!/usr/bin/env bats

load helpers/common.sh


NAME="git-current.sh"
DIR="$( dirname "$BATS_TEST_DIRNAME" )/src"
SCRIPT="$DIR/$NAME"


setup() {
  source $SCRIPT

  # create mock git repo
  MOCK_REPO="$BATS_TEST_TMPDIR/repo"
  initialize_repo $MOCK_REPO

  # create and switch to a new branch name
  CURRENT_BRANCH="Panda_Bear"
  create_branch $CURRENT_BRANCH
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


confirm_branch() {
  local branch=$1

  [ "$status" -eq 0 ]
  ! [ -z "$output" ]
  [[ "$output" = "$branch" ]]
}


@test "Confirm $NAME output" {
  run sh $SCRIPT

  confirm_branch $CURRENT_BRANCH
}


@test "Confirm $NAME output after checkout" {
  # checkout main
  local b="main"
  checkout $b

  run sh $SCRIPT

  confirm_branch $b
}


@test "Confirm lib fn output" {
  source "$DIR/lib.sh"

  run get_current_branch

  confirm_branch $CURRENT_BRANCH
}
