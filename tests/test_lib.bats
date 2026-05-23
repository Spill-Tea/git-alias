#!/usr/bin/env bats


load helpers/common.sh


NAME="lib.sh"
DIR="$( dirname "$BATS_TEST_DIRNAME" )/src"
SCRIPT="$DIR/$NAME"


setup() {
  source $SCRIPT

  # create mock git repo
  MOCK_REPO="$BATS_TEST_TMPDIR/repo"
  initialize_repo $MOCK_REPO

  # create linked branches
  BRANCH_A="otter"
  create_branch $BRANCH_A
  add "a" "$BRANCH_A.txt"

  BRANCH_B="capybara"
  create_branch $BRANCH_B
  add "b" "$BRANCH_B.txt"

  # create independent branch
  checkout main
  BRANCH_C="echidna"
  create_branch $BRANCH_C
  add "c" "$BRANCH_C.txt"
}


teardown() {
  rm -rf $MOCK_REPO
}


@test "test is_ancestor AB" {
    run is_ancestor $BRANCH_A $BRANCH_B

    [ $status -eq 0 ]
    [ -z $output ]
}


@test "test is_ancestor BA fails" {
    run is_ancestor $BRANCH_B $BRANCH_A

    [ $status -eq 1 ]
    [ -z $output ]
}


@test "test is_ancestor mainA" {
    run is_ancestor main $BRANCH_A 

    [ $status -eq 0 ]
    [ -z $output ]
}


@test "test is_ancestor Amain fails" {
    run is_ancestor $BRANCH_A main

    [ $status -eq 1 ]
    [ -z $output ]
}


@test "test is_ancestor mainB" {
    run is_ancestor main $BRANCH_B

    [ $status -eq 0 ]
    [ -z $output ]
}


@test "test is_ancestor Bmain fails" {
    run is_ancestor $BRANCH_B main

    [ $status -eq 1 ]
    [ -z $output ]
}


@test "test is_ancestor AC fails" {
    run is_ancestor $BRANCH_A $BRANCH_C

    [ $status -eq 1 ]
    [ -z $output ]
}


@test "test is_ancestor CA fails" {
    run is_ancestor $BRANCH_C $BRANCH_A

    [ $status -eq 1 ]
    [ -z $output ]
}


@test "test is_ancestor BC fails" {
    run is_ancestor $BRANCH_B $BRANCH_C

    [ $status -eq 1 ]
    [ -z $output ]
}


@test "test is_ancestor CB fails" {
    run is_ancestor $BRANCH_C $BRANCH_B

    [ $status -eq 1 ]
    [ -z $output ]
}


@test "test is_ancestor Cmain fails" {
    run is_ancestor $BRANCH_C main

    [ $status -eq 1 ]
    [ -z $output ]
}


@test "test is_ancestor mainC" {
    run is_ancestor main $BRANCH_C

    [ $status -eq 0 ]
    [ -z $output ]
}


@test "test list_branches" {
    run list_branches
    [ $status -eq 0 ]
    ! [ -z $output ]

    run assert_lines_equal "main" "$BRANCH_A" "$BRANCH_B" "$BRANCH_C"
    [ $status -eq 0 ]
    [ -z $output ]
}


 @test "test get_help (no args)" {
     run get_help
     [ $status -eq 1 ]
     [ -z $output ]
 }


 @test "test get_help -h" {
     run get_help -h
     [ $status -eq 0 ]
     [ -z $output ]
 }


 @test "test get_help -h (buried)" {
     run get_help 1 --other value --another=key -h
     [ $status -eq 0 ]
     [ -z $output ]
 }


 @test "test get_help --help" {
     run get_help --help
     [ $status -eq 0 ]
     [ -z $output ]
 }


 @test "test get_help --help (buried)" {
     run get_help 1 --other value --another=key --help --more
     [ $status -eq 0 ]
     [ -z $output ]
 }


 @test "test calculate_distance AB" {
     run calculate_distance $BRANCH_A $BRANCH_B

     [ $status -eq 0 ]
     [ "$output" = "1" ]
 }


 @test "test calculate_distance mainB" {
     run calculate_distance main $BRANCH_B

     [ $status -eq 0 ]
     [ "$output" = "2" ]
 }


 @test "test calculate_distance mainC" {
     run calculate_distance main $BRANCH_C

     [ $status -eq 0 ]
     [ "$output" = "1" ]
 }
