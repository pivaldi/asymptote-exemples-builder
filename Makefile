SHELL := /bin/bash

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(patsubst %/,%,$(dir $(mkfile_path)))

generate_xml_cmd := ROOT_PROJECT_DIR=$(current_dir) ./bin/asy-generate-xml-files.sh

.PHONY: all
all: build-xml-all

.PHONY: clean
clean: build-clean
	[ -e tmp ] && rm -r tmp || true

.PHONY: build-mk-dirs
build-mk-dirs:
	ROOT_PROJECT_DIR=$(current_dir) ./bin/asy-build-mkdirs.sh

.PHONY: build-clean
build-clean:
	[ -e build ] && rm -r build || true

.PHONY: build-xml-all
build-xml-all:
	$(generate_xml_cmd)

.PHONY: build-xml-generalities
build-xml-generalities: build-mk-dirs
	$(generate_xml_cmd) generalities

.PHONY: build-xml-geometry
build-xml-geometry: build-mk-dirs
	$(generate_xml_cmd) geometry

.PHONY: build-xml-various
build-xml-various: build-mk-dirs
	$(generate_xml_cmd) various

.PHONY: build-xml-grid3
build-xml-grid3: build-mk-dirs
	$(generate_xml_cmd) grid3

.PHONY: build-xml-fractales
build-xml-fractales: build-mk-dirs
	$(generate_xml_cmd) fractales

.PHONY: build-xml-opacity
build-xml-opacity: build-mk-dirs
	$(generate_xml_cmd) opacity

.PHONY: build-xml-trembling
build-xml-trembling: build-mk-dirs
	$(generate_xml_cmd) trembling

.PHONY: build-xml-lsystem
build-xml-lsystem: build-mk-dirs
	$(generate_xml_cmd) lsystem

.PHONY: build-xml-randomwalk
build-xml-randomwalk: build-mk-dirs
	$(generate_xml_cmd) randomwalk

.PHONY: build-xml-graph
build-xml-graph: build-mk-dirs
	$(generate_xml_cmd) graph

# .PHONY: build-xml-modules
# build-xml-modules: build-mk-dirs
# 	$(generate_xml_cmd) modules
