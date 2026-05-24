#!/usr/bin/env bats

load helpers/common.sh


NAME="git-unstage.sh"
DIR="$( dirname "$BATS_TEST_DIRNAME" )/src"
SCRIPT="$DIR/$NAME"


setup() {
  source $SCRIPT

  # create mock git repo
  MOCK_REPO="$BATS_TEST_TMPDIR/repo"
  initialize_repo $MOCK_REPO

  # create and switch to a new branch name
  CURRENT_BRANCH="busy_beaver"
  create_branch $CURRENT_BRANCH

  FILE_NAME="beaver.txt"
  stage "build dam" $FILE_NAME
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


@test "Confirm $NAME output without required argument" {
  run sh $SCRIPT

  [ "$status" -eq 1 ]
  ! [ -z "$output" ]
  [[ "$output" =~ Aborting* ]]
}


# NOTE: we can unstage a file that is not currently staged without issue.
@test "Confirm $NAME output unstaged file" {
  run sh $SCRIPT $FILE_NAME

  [ "$status" -eq 0 ]
  [ -z "$output" ]
}


@test "Confirm alias output without required argument" {
  # create git alias to script 
  local name="vv5h43mqz"
  alias $name $SCRIPT

  run git $name

  [ "$status" -eq 1 ]
  ! [ -z "$output" ]
  [[ "$output" =~ Aborting* ]]
}


@test "Confirm alias output unstaged file" {
  # create git alias to script 
  local name="vv5h43mqz"
  alias $name $SCRIPT

  run git $name $FILE_NAME

  [ "$status" -eq 0 ]
  [ -z "$output" ]
}
