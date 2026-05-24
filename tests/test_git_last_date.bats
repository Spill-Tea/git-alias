#!/usr/bin/env bats

load helpers/common.sh


NAME="git-last-date.sh"
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


@test "Confirm $NAME -h displays help menu 1" {
  run sh $SCRIPT -h

   _assert_help_menu_standard $NAME
}


@test "Confirm $NAME --help displays help menu 2" {
  run sh $SCRIPT --help

   _assert_help_menu_standard $NAME
}


# Confirm ISO8601 DateTime format
confirm_date_format() {
  local d="[0-9]"
  local date="^$d{4}-[01]$d-[0-3]$d"
  local time="T[0-2]$d:[0-5]$d:[0-5]$d"
  local zone="[+-][0-2]$d:[0-5]$d"

  [ "$status" -eq 0 ]
  ! [ -z "$output" ]

  [[ "$output" =~ $date$time$zone ]]
}


@test "Confirm $NAME output" {
  run sh $SCRIPT

  confirm_date_format

}


@test "Confirm $NAME fn output" {
  run get_last_date

  confirm_date_format

}


@test "Confirm alias output" {
  # create git alias to script 
  local name="pe50wcmztu"
  alias $name $SCRIPT

  run git $name

  confirm_date_format
}
