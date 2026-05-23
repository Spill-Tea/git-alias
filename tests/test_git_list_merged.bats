#!/usr/bin/env bats

load helpers/common.sh


NAME="git-list-merged.sh"
DIR="$( dirname "$BATS_TEST_DIRNAME" )/src"
SCRIPT="$DIR/$NAME"


setup() {
  source $SCRIPT

  # create mock git repo
  MOCK_REPO="$BATS_TEST_TMPDIR/repo"
  initialize_repo $MOCK_REPO

  # Create a new branch with commit and push to remote
  BRANCH="Unicorns"
  create_branch $BRANCH
  add "new feature" "unicorn.py"
  push $BRANCH

  # merge new branch to main, and push main to remote
  checkout "main"
  merge $BRANCH "special unicorn branch."
  push "main"
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


@test "Confirm $NAME output" {
  run sh $SCRIPT

  [ "$status" -eq 0 ]
  ! [ -z "$output" ]
  [[ "$output" = $BRANCH ]]
}


@test "Confirm lib fn output" {
  source "$DIR/lib.sh"

  run list_merged_branches

  [ "$status" -eq 0 ]
  ! [ -z "$output" ]
  [[ "$output" = $BRANCH ]]
}


@test "Confirm lib fn fails with invalid branch name" {
  source "$DIR/lib.sh"

  run list_merged_branches "invalid_branch_name"

  [ "$status" -eq 1 ]
  ! [ -z "$output" ]
  [[ "$output" = "Aborting."* ]]
}
