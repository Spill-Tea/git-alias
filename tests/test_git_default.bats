#!/usr/bin/env bats

load helpers/common.sh


NAME="git-default.sh"
DIR="$( dirname "$BATS_TEST_DIRNAME" )/src"
SCRIPT="$DIR/$NAME"


setup() {
  source $SCRIPT

  # create mock git repo
  MOCK_REPO="$BATS_TEST_TMPDIR/repo"
  initialize_repo $MOCK_REPO

  # create and switch to a new branch name
  CURRENT_BRANCH="Narwhal"
  create_branch $CURRENT_BRANCH
}


teardown() {
  rm -rf $MOCK_REPO
}


@test "Confirm show_help_menu output" {
  run show_help_menu

  _assert_help_menu_standard $NAME
}


@test "Confirm $NAME -h displays help menu 1" {
  run sh $SCRIPT -h

  _assert_help_menu_standard $NAME
}


@test "Confirm $NAME --help displays help menu 2" {
  run sh $SCRIPT --help

  _assert_help_menu_standard $NAME
}


confirm_default() {
  [ "$status" -eq 0 ]
  ! [ -z "$output" ]
  [[ "$output" == "main" ]]
}


@test "Confirm $NAME output" {
  run sh $SCRIPT

  confirm_default
}


@test "Confirm lib fn output" {
  source "$DIR/lib.sh"

  run get_default_branch

  confirm_default
}


@test "Confirm alias output" {
  # create git alias to script
  local name="nkl48sdp"
  alias $name $SCRIPT

  run git $name

  confirm_default
}
