SHELL := /bin/bash

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(patsubst %/,%,$(dir $(mkfile_path)))

generate_xml_cmd := $(current_dir)/bin/generate-xmls.sh

.PHONY: all
all: build-xml-all

.PHONY: clean
clean: build-clean
	[ -e "$(current_dir)/tmp" ] && rm -r "$(current_dir)/tmp" || true

.PHONY: build-mkdirs
build-mkdirs:
	$(current_dir)/bin/mkdirs.sh

.PHONY: build-clean
build-clean:
	[ -e "$(current_dir)/build" ] && rm -r "$(current_dir)/build" || true

.PHONY: build-xmls
build-xmls: build-mkdirs
	$(generate_xml_cmd)
