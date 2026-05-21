#!/usr/bin/env bats

load helpers/common.sh


NAME="git-logs.sh"
SCRIPT="$( dirname "$BATS_TEST_DIRNAME" )/src/$NAME"


setup() {
  source $SCRIPT
}


@test "Confirm show_help_menu output" {
  run show_help_menu

  _assert_help_menu_standard $NAME
}


@test "Confirm $NAME -h displays help menu" {
  run sh $SCRIPT -h

  _assert_help_menu_standard $NAME
}


@test "Confirm $NAME --help displays help menu 2" {
  run sh $SCRIPT --help

  _assert_help_menu_standard $NAME
}


@test "Confirm $NAME output" {

  d="[0-9]"
  log_fmt="[a-z0-9]{7} $d{4}-[01]$d-[0-3]$d "

  for p in 1 2 3; do
    run sh $SCRIPT -n $p

    [ "$status" -eq 0 ]
    ! [ -z "$output" ]
    [[ "$output" =~ $log_fmt*" (@"*")"* ]]
    [ "${#lines[@]}" -eq $p ]

  done
}
