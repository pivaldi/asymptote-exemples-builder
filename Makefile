SHELL := /bin/bash

# Make is verbose in Linux. Make it silent.
MAKEFLAGS += --silent

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(patsubst %/,%,$(dir $(mkfile_path)))

generate_xmls_cmd := $(current_dir)/bin/generate-xmls.sh
generate_html_cmd := $(current_dir)/bin/generate-html.sh
generate_assets_cmd := $(current_dir)/bin/generate-assets.sh
generate_md_hexo_cmd := $(current_dir)/bin/generate-md-hexo.sh

.PHONY: all
all: install assets xmls html md-hexo

.PHONY: install
install: ## Launch some commands to ensure the project is fully installed (git submodule for example).
	./bin/install.sh

.PHONY: clean ## Clean all directories used to generate files (webp, xml, html, md, etc).
clean: build-clean assets-clean
	[ -e "$(current_dir)/tmp" ] && rm -r "$(current_dir)/tmp" || true

.PHONY: build-clean
build-clean: ## Clean the build directory where live all generated files.
	[ -e "$(current_dir)/build" ] && rm -r "$(current_dir)/build" || true

.PHONY: assets
assets: install ## Build all the Asymptote codes' example only if the example is newer than the generated picture.
	$(generate_assets_cmd)

.PHONY: xmls
xmls: assets ## Generate xml files from asy build files. XML files are the base files that can be tread by xsl files to generate various format.
	$(generate_xmls_cmd)

.PHONY: html
html: xmls ## Generate in build/html/ all the html files to browse the Asymptote Example Codes base.
	$(generate_html_cmd)

.PHONY: md-hexo
md-hexo: xmls ## Generate the markdown files for Hexo with individual posts, specific topics pages, specific categoies pages and specific tags pages.
	$(generate_md_hexo_cmd)

.PHONY: assets-clean
assets-clean: ## Clean the compiled Asymptote pictures and pdf on the asy build dir.
	[ -e "$(current_dir)/build/asy" ] && rm -r "$(current_dir)/build/asy" || true

.PHONY: sync-hexo
sync-hexo: ## Usage for pivaldi only. Synchronize to local hexo directory.
	$(current_dir)/bin/sync-to-hexo-blog.sh

.PHONY: deploy-hexo
deploy-hexo: assets xmls md-hexo sync-hexo ## Usage for blog.piprime.fr only. Synchronize to my personal Hexo blog.
	$(current_dir)/bin/sync-to-hexo-blog.sh

.PHONY: help
help: ## Prints this help
	@grep -h -P '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		column -t -s ':' -o ':' | \
		sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36mmake  %s\033[0m : %s\n", $$1, $$2}'
