#!/usr/bin/env bats

NAME="git-last-date.sh"
SCRIPT="$( dirname "$BATS_TEST_DIRNAME" )/src/$NAME"


setup() {
  source $SCRIPT
}


@test "Confirm show_help_menu output" {
  run show_help_menu

  [ "$status" -eq 0 ]
  [[ "$output" = *"Usage:"* ]]
  [[ "$output" = *"$NAME"* ]]
}


@test "Confirm $NAME -h displays help menu" {
  run sh $SCRIPT -h

  [ "$status" -eq 0 ]
  [[ "$output" = *"Usage:"* ]]
  [[ "$output" = *"$NAME"* ]]
}


@test "Confirm $NAME --help displays help menu 2" {
  run sh $SCRIPT --help

  [ "$status" -eq 0 ]
  [[ "$output" = *"Usage:"* ]]
  [[ "$output" = *"$NAME"* ]]
}


@test "Confirm $NAME output" {
  run sh $SCRIPT

  [ "$status" -eq 0 ]
  ! [ -z "$output" ]

  # Confirm ISO8601 DateTime format
  d="[0-9]"
  date="^$d{4}-[01]$d-[0-3]$d"
  time="T[0-2]$d:[0-5]$d:[0-5]$d"
  zone="[+-][0-2]$d:[0-5]$d"

  [[ "$output" =~ $date$time$zone ]]

}
