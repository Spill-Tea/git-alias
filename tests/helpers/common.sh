#!/usr/bin/env bash

# confirm help menu displays correctly and conforms
# to standardized format presentation.
_assert_help_menu_standard() {
  NAME=$1

  [ "$status" -eq 0 ]

  # confirm menu has all expected titles
  for k in "Usage" "Description" "Options" "Examples"; do
    [[ "$output" = *"$k:"* ]]
  done

  # help menu contains name of script
  [[ "$output" = *"$NAME"* ]]

  # NOTE: output variable is stripped of ending lines
  #       making it difficult to confirm standard in testing.
  #   [[ "$output" = *"\n" ]]
}
