#!/usr/bin/env bats

load helpers/common.sh


NAME="git-unstage.sh"
SCRIPT="$( dirname "$BATS_TEST_DIRNAME" )/src/$NAME"


setup() {
  source $SCRIPT
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


@test "Confirm $NAME output without required argument" {
  run sh $SCRIPT

  [ "$status" -eq 1 ]
  ! [ -z "$output" ]
  [[ "$output" =~ Aborting* ]]
}


# NOTE: we can unstage a file that is not currently staged without issue.
@test "Confirm $NAME output unstaged file" {
  run sh $SCRIPT "LICENSE"

  [ "$status" -eq 0 ]
  [ -z "$output" ]
}
