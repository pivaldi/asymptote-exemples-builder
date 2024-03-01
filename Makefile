SHELL := /bin/bash

# Make is verbose in Linux. Make it silent.
MAKEFLAGS += --silent

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(patsubst %/,%,$(dir $(mkfile_path)))

generate_xml_cmd := $(current_dir)/bin/generate-xmls.sh

.PHONY: all
all: build-xml-all

.PHONY: clean
clean: build-clean assets-clean
	[ -e "$(current_dir)/tmp" ] && rm -r "$(current_dir)/tmp" || true
	[ -e "$(current_dir)/bin/config.rc" ] && rm "$(current_dir)/bin/config.rc" || true

.PHONY: build-mkdirs
build-mkdirs:
	$(current_dir)/bin/mkdirs.sh

.PHONY: build-clean
build-clean:
	[ -e "$(current_dir)/build" ] && rm -r "$(current_dir)/build" || true

.PHONY: build-xmls
build-xmls: build-mkdirs
	$(generate_xml_cmd)

.PHONY: assets-clean
assets-clean:
	[ -e "$(current_dir)/build/asset" ] && rm -r "$(current_dir)/build/asset" || true
