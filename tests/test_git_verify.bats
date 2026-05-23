#!/usr/bin/env bats

load helpers/common.sh


NAME="git-verify.sh"
DIR="$( dirname "$BATS_TEST_DIRNAME" )/src"
SCRIPT="$DIR/$NAME"


setup() {
  # create mock git repo
  MOCK_REPO="$BATS_TEST_TMPDIR/repo"
  initialize_repo $MOCK_REPO
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


@test "Confirm $NAME output without required argument" {
  run sh $SCRIPT

  [ "$status" -eq 1 ]
  ! [ -z "$output" ]
  [[ "$output" =~ Aborting* ]]
}


confirm_verification() {
  [ "$status" -eq 0 ]
  ! [ -z "$output" ]
  [[ "${#output}" -eq "40" ]]
  [[ "$output" =~ [a-z0-9]{40} ]]
}


@test "Confirm $NAME output returns sha hash" {
  run sh $SCRIPT main

  confirm_verification
}


@test "Confirm lib fn output failure" {
  source "$DIR/lib.sh"

  run verify

  [ "$status" -eq 1 ]
  [ -z "$output" ]
}


@test "Confirm lib fn output" {
  source "$DIR/lib.sh"

  run verify main

  confirm_verification
}


@test "Confirm lib fn validate output" {
  source "$DIR/lib.sh"

  run validate main

  [ "$status" -eq 0 ]
  [ -z "$output" ]
}


@test "Confirm lib fn validate output fail" {
  source "$DIR/lib.sh"

  local branch="mock_branch"
  run validate $branch

  [ "$status" -eq 1 ]
  ! [ -z "$output" ]
  [[ "$output" = "Aborting"* ]]
  [[ "$output" = *"$branch"* ]]
}
