.PHONY: test lint

test:
	tests/bats/bin/bats \
		--pretty \
		--timing \
		--print-output-on-failure \
		--line-reference-format colon \
		tests/

lint:
	prek run --all-files
