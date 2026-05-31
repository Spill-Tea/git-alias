#!/usr/bin/env bats

load helpers/common.sh


NAME="git-stack.sh"
DIR="$( dirname "$BATS_TEST_DIRNAME" )/src"
SCRIPT="$DIR/$NAME"


setup() {
  source $SCRIPT

  # create mock git repo
  MOCK_REPO="$BATS_TEST_TMPDIR/repo"
  initialize_repo $MOCK_REPO

  STACKED_BRANCHES=()
  local j
  local branch
  for j in 1 2 3; do
    branch="branch_$j"
    create_branch $branch
    add "part of stack $j"
    STACKED_BRANCHES+=($branch)
  done
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


_confirm_output() {
  [ "$status" -eq 0 ]
  ! [ -z "$output" ]
  assert_lines_equal "$@"
}


# general unit test handler to processively work up the stack, checkout the branch, and
# evaluate the expected output meets expected, accepting a function expression to run.
confirm_stack() {
  local expression_fn=$1

  for i in "${!STACKED_BRANCHES[@]}"; do
    checkout ${STACKED_BRANCHES[$i]}

    run $expression_fn

    _confirm_output "${STACKED_BRANCHES[@]:0:$((i + 1))}"
  done
}


# TODO: create a git flow model repo for testing such that we have a dev branch that has
#       been merged to default main branch once, but is still ahead of main. then create
#       a stack on the dev branch. and confirm output of script with user provided
#       argument to dev branch.
@test "Confirm $NAME output" {
  confirm_stack "bash $SCRIPT main"
}


@test "Confirm lib fn output" {
  source "$DIR/lib.sh"

  confirm_stack "get_stacked_branches main"
}


@test "Confirm alias output" {
  # create git alias to script
  local name="h5rdss9lk"
  alias $name $SCRIPT

  confirm_stack "git $name"
}
