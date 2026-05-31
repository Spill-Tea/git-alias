#!/usr/bin/env bats

load helpers/common.sh


NAME="git-sync.sh"
DIR="$( dirname "$BATS_TEST_DIRNAME" )/src"
SCRIPT="$DIR/$NAME"


setup() {
  source $SCRIPT
  source $DIR/lib.sh

  # create mock git repo
  MOCK_REPO="$BATS_TEST_TMPDIR/repo"
  initialize_repo $MOCK_REPO

  # create a new branch name
  CURRENT_BRANCH="Panda_Bear"
  create_branch $CURRENT_BRANCH
  add "message 1" "panda.txt"
  push $CURRENT_BRANCH

  # move to seed repo
  cd "$MOCK_REPO/seed"
  checkout main
  pull

  # modify main and push change to remote
  MESSAGE="ube boba"
  add "$MESSAGE" "goose.txt"
  push main

  # move back to working repo
  cd "$MOCK_REPO/work"
  checkout $CURRENT_BRANCH
}


teardown() {
  rm -rf $MOCK_REPO
}


@test "Confirm show_help_menu output" {
  run show_help_menu

  _assert_help_menu_standard $NAME
}


@test "Confirm $NAME -h output help menu 1" {
  run bash $SCRIPT -h

  _assert_help_menu_standard $NAME
}


@test "Confirm $NAME --help output help menu 2" {
  run bash $SCRIPT --help

  _assert_help_menu_standard $NAME
}


@test "Confirm alias -h displays help menu" {
  local name="h4b28uai"
  alias $name $SCRIPT
  run git $name -h

  _assert_help_menu_standard $NAME
}


confirm_sync() {
  # sanity checks
  [ "$status" -eq 0 ]
  ! [[ -z $output ]]

  # confirm we returned to current branch
  run get_current_branch
  [ "$status" -eq 0 ]
  [ "$output" = "$CURRENT_BRANCH" ]

  # confirm commit msg is rebased to branch
  run git log -n 2 --pretty=oneline
  [[ "$output" = *$MESSAGE ]]
  [[ "${lines[1]}" = *$MESSAGE ]]
}


@test "Confirm $NAME output." {
  run bash $SCRIPT

  confirm_sync
}


@test "Confirm $NAME main output." {
  run bash $SCRIPT main

  confirm_sync
}


@test "Confirm $NAME main current output." {
  run bash $SCRIPT main $CURRENT_BRANCH

  confirm_sync
}


@test "Confirm lib fn output." {
  run sync

  confirm_sync
}


@test "Confirm lib fn main output." {
  run sync main

  confirm_sync
}


@test "Confirm lib fn main current output." {
  run sync main $CURRENT_BRANCH

  confirm_sync
}


@test "Confirm alias output." {
  local name="h4b28uai"
  alias $name $SCRIPT

  run git $name

  confirm_sync
}


@test "Confirm alias main output." {
  local name="h4b28uai"
  alias $name $SCRIPT

  run git $name main

  confirm_sync
}


@test "Confirm alias main current output." {
  local name="h4b28uai"
  alias $name $SCRIPT

  run git $name main $CURRENT_BRANCH

  confirm_sync
}
