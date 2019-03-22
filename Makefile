sources=$(shell find src -type f)
target=mantling.pk3

build/$(target): $(sources)
	7z a -tzip $@ ./src/*

clean:
	rm -r build/*

.PHONY: clean
