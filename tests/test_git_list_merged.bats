#!/usr/bin/env bats

load helpers/common.sh


NAME="git-list-merged.sh"
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


# TODO: Determine how to construct a mock git repo
#       to have consistent expected answers, and a variety of edge cases.
# @test "Confirm $NAME output" {
#   run sh $SCRIPT

#   [ "$status" -eq 0 ]
#   echo $output
#   [ -z "$output" ]
# }
