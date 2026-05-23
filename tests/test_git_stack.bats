#!/usr/bin/env bats

load helpers/common.sh


NAME="git-stack.sh"
DIR="$( dirname "$BATS_TEST_DIRNAME" )/src"
SCRIPT="$DIR/$NAME"


setup() {
  source $SCRIPT

  # create mock git repo
  MOCK_REPO="$BATS_TEST_TMPDIR/repo"
  initialize_repo $MOCK_REPO

  # create branch 1
  BRANCH1="branch1"
  create_branch $BRANCH1
  add "part of stack 1"

  # create branch 2
  BRANCH2="branch2"
  create_branch $BRANCH2
  add "part of stack 2"
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


confirm_stack() {
  [ "$status" -eq 0 ]
  ! [ -z "$output" ]
  assert_lines_equal "$@"
}


# TODO: create a git flow model repo for testing
#       such that we have a dev branch that has been merged to
#       default main branch once, but is still ahead of main.
#       then create a stack on the dev branch. and confirm
#       output of script with user provided argument to dev branch.
@test "Confirm $NAME output" {
  run sh $SCRIPT

  confirm_stack "$BRANCH1" "$BRANCH2"
}


@test "Confirm lib fn output" {
  source "$DIR/lib.sh"

  run get_stacked_branches "main"

  confirm_stack "$BRANCH1" "$BRANCH2"
}
