#!/usr/bin/env bats

load helpers/common.sh


NAME="git-stack.sh"
DIR="$( dirname "$BATS_TEST_DIRNAME" )/src"
SCRIPT="$DIR/$NAME"


create_stacked_branches() {
  STACKED_BRANCHES=()
  local j
  local branch
  for j in 1 2 3; do
    branch="branch_$j"
    create_branch $branch
    add "part of stack $j" "page_$j.txt"
    STACKED_BRANCHES+=($branch)
  done
}


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
  local i
  local expression_fn=$1

  create_stacked_branches
  for i in "${!STACKED_BRANCHES[@]}"; do
    checkout ${STACKED_BRANCHES[$i]}

    run $expression_fn

    _confirm_output "${STACKED_BRANCHES[@]:0:$((i + 1))}"
  done
}


@test "Confirm $NAME output" {
  confirm_stack "bash $SCRIPT"
}


@test "Confirm $NAME main output" {
  confirm_stack "bash $SCRIPT main"
}


@test "Confirm $NAME git flow output" {
  local dev="dev_branch"

  setup_git_flow_model $MOCK_REPO $dev
  checkout $dev

  confirm_stack "bash $SCRIPT $dev"
}


@test "Confirm lib fn output" {
  source "$DIR/lib.sh"

  confirm_stack "get_stacked_branches main"
}


@test "Confirm lib fn git flow output" {
  source "$DIR/lib.sh"

  local dev="dev_branch"
  setup_git_flow_model $MOCK_REPO $dev
  checkout $dev

  confirm_stack "get_stacked_branches $dev"
}


@test "Confirm alias output" {
  # create git alias to script
  local name="h5rdss9lk"
  alias $name $SCRIPT

  confirm_stack "git $name"
}


@test "Confirm alias main output" {
  # create git alias to script
  local name="h5rdss9lk"
  alias $name $SCRIPT

  confirm_stack "git $name main"
}


@test "Confirm alias git flow output" {
  # create git alias to script
  local name="h5rdss9lk"
  alias $name $SCRIPT

  local dev="development"

  setup_git_flow_model $MOCK_REPO $dev
  checkout $dev

  confirm_stack "git $name $dev"
}
