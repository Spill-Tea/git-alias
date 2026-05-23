#!/usr/bin/env bats

load helpers/common.sh


NAME="git-sha.sh"
DIR="$( dirname "$BATS_TEST_DIRNAME" )/src"
SCRIPT="$DIR/$NAME"


setup() {
  source $SCRIPT

  # create mock git repo
  MOCK_REPO="$BATS_TEST_TMPDIR/repo"
  initialize_repo $MOCK_REPO
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


confirm_sha() {
  [ "$status" -eq 0 ]
  ! [ -z "$output" ]
  [[ "$output" =~ [a-z0-9]{7} ]]
}


@test "Confirm $NAME output" {
  run sh $SCRIPT

  confirm_sha
}


@test "Confirm lib fn output" {
  source "$DIR/lib.sh"

  run get_current_sha

  confirm_sha
}
