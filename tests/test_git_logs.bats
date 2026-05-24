#!/usr/bin/env bats

load helpers/common.sh


NAME="git-logs.sh"
DIR="$( dirname "$BATS_TEST_DIRNAME" )/src"
SCRIPT="$DIR/$NAME"


setup() {
  source $SCRIPT

  # create mock git repo
  MOCK_REPO="$BATS_TEST_TMPDIR/repo"
  initialize_repo $MOCK_REPO

  # Create a few more commits (so we have 3 at least)
  add "msg 1"
  add "msg 2"
}


teardown() {
  rm -rf $MOCK_REPO
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


confirm_log_format() {
  local p=$1
  local d="[0-9]"
  local log_fmt="[a-z0-9]{7} $d{4}-[01]$d-[0-3]$d "

  [ "$status" -eq 0 ]
  ! [ -z "$output" ]
  [[ "$output" =~ $log_fmt*" (@Test User)"* ]]
  if ! [ -z $p ]; then
    [ "${#lines[@]}" -eq $p ]
  fi
}


@test "Confirm $NAME output" {
  # create git alias to script
  local name="jJ2Waxzp073"
  alias $name $SCRIPT

  for p in 1 2 3; do
    run git $name -n $p
    confirm_log_format $p
  done
}


@test "Confirm alias output" {

  for p in 1 2 3; do
    run sh $SCRIPT -n $p
    confirm_log_format $p
  done
}


@test "Confirm $NAME fn output" {

  for p in 1 2 3; do
    run pretty_log -n $p
    confirm_log_format $p
  done
}
