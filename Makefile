.PHONY: test
test:
	mix test --cover

watch:
	mix test.watch

format:
	mix format

lint:
	mix credo

lint_strict:
	mix credo --strict

analyze:
	mix dialyzer

doc:
	mix docs
