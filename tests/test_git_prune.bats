#!/usr/bin/env bats

load helpers/common.sh


NAME="git-prune.sh"
DIR="$( dirname "$BATS_TEST_DIRNAME" )/src"
SCRIPT="$DIR/$NAME"

source $DIR/lib.sh


setup() {
  # create mock git repo
  MOCK_REPO="$BATS_TEST_TMPDIR/repo"
  initialize_repo $MOCK_REPO

  # Create a new branch with commit and push to remote
  BRANCH="peeps"
  create_branch $BRANCH
  add "new_feature" "peep.py"
  push $BRANCH

  # merge new branch to main, and push main to remote
  checkout "main"
  merge $BRANCH "special peep branch."
  push "main"

  # setup decoy (unmerged) branch
  DECOY_BRANCH="ducky_decoy"
  create_branch $DECOY_BRANCH
  add "quack" "duck.txt"
  push $DECOY_BRANCH
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
  run sh $SCRIPT -h

  _assert_help_menu_standard $NAME
}


@test "Confirm $NAME --help output help menu 2" {
  run sh $SCRIPT --help

  _assert_help_menu_standard $NAME
}


confirm_pruning() {
  local branch=$1

  [ "$status" -eq 0 ]
  [[ "$output" =~ "Deleted branch $branch"* ]]
  ! [[ "$output" = *"$DECOY_BRANCH"* ]]

  run list_branches

  ! in_line $branch "${lines[@]}"
  in_line $DECOY_BRANCH "${lines[@]}"
}


@test "Confirm $NAME output" {
  run sh $SCRIPT

  confirm_pruning $BRANCH
}


@test "Confirm lib fn output" {
  run prune_branches

  confirm_pruning $BRANCH
}


@test "Confirm alias output" {
  # create git alias to script
  local name="nsfchv335s"
  alias $name $SCRIPT

  run git $name

  confirm_pruning $BRANCH
}
