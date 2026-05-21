#!/usr/bin/env bats

load helpers/common.sh


NAME="git-prune.sh"
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


# TODO: Need to consider how to set this up in a mock git repo
#       such that we have a consistent expected result. And more
#       methodical testing of edge cases.
# @test "Confirm $NAME output" {
#   run sh $SCRIPT

#   [ "$status" -eq 0 ]
#   ! [ -z "$output" ]
# }
