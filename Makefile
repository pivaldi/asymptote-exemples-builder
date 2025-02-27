SHELL := /bin/bash

# Make is verbose in Linux. Make it silent.
MAKEFLAGS += --silent

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(patsubst %/,%,$(dir $(mkfile_path)))

generate_xmls_cmd := $(current_dir)/bin/generate-xmls.sh
generate_html_cmd := $(current_dir)/bin/generate-html.sh
generate_assets_cmd := $(current_dir)/bin/generate-assets.sh

.PHONY: all
all: install assets xmls html

.PHONY: install
install:
	./bin/install.sh

.PHONY: clean
clean: build-clean assets-clean
	[ -e "$(current_dir)/tmp" ] && rm -r "$(current_dir)/tmp" || true
	./bin/install.sh

.PHONY: build-clean
build-clean:
	[ -e "$(current_dir)/build" ] && rm -r "$(current_dir)/build" || true

.PHONY: assets
assets:
	$(generate_assets_cmd)

.PHONY: xmls
xmls:
	$(generate_xmls_cmd)

.PHONY: html
html:
	$(generate_html_cmd)

.PHONY: assets-clean
assets-clean:
	[ -e "$(current_dir)/build/asset" ] && rm -r "$(current_dir)/build/asset" || true
