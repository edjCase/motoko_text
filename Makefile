.PHONY: check docs test

check:
	find src -type f -name '*.mo' -print0 | xargs -0 $(shell vessel bin)/moc $(shell mops sources) --check

all: check-strict docs test

check-strict:
	find src -type f -name '*.mo' -print0 | xargs -0 $(shell vessel bin)/moc $(shell mops sources) -Werror --check
docs:
	$(shell vessel bin)/mo-doc
test:
	mkdir -p build/
	$(shell vessel bin)/moc $(shell mops sources) -wasi-system-api -o build/Tests.wasm test/Tests.mo && wasmtime build/Tests.wasm
	rm -f build/Tests.wasm

