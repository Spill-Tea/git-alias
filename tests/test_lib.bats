#!/usr/bin/env bats


NAME="lib.sh"
SCRIPT="$( dirname "$BATS_TEST_DIRNAME" )/src/$NAME"


setup() {
  source $SCRIPT
}


@test "test lib.get_default_branch fn" {
    run get_default_branch

    [ $status = 0 ]
    [ $output = "main" ]
}


@test "test lib.get_current_branch fn" {
    run get_current_branch

    [ $status = 0 ]
    ! [ -z "$output" ]
}


@test "test lib.get_current_sha fn" {
    run get_current_sha

    [ $status = 0 ]
    ! [ -z "$output" ]
    [[ "$output" =~ [a-z0-9]{7} ]]
}
