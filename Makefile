
SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --output-sync=target
n_prc := $(shell sysctl -n hw.logicalcpu)
MAKEFLAGS := --jobs=$(n_prc)
cmd_bats := bats --jobs $(n_prc)

# ifeq ($(origin .RECIPEPREFIX), undefined)
# 				$(error This Make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later)
# endif
# .RECIPEPREFIX = >

plots := ratio_type ratio_urgency ratio_pain

.PHONY: build

build: ;

# str_find_query := -iname '2022*' -o -iname '2023*'
# dir_reporter := $(HOME)/Dropbox/Apps/Reporter-App/
# files_reporter_data := $(shell find $(dir_reporter) $(str_find_query))
file_data := data.json

build/data_0.sigil: $(file_data)
	mkdir -p "$(basename $@)"
	cp $(file_data) "$(basename $@)"
	touch "$@"

build/data_1.json: build/data_0.sigil transformers/transform.jq
	./transformers/transform.jq "$(file_data)" > "$@"

build/data_2.tsv: build/data_1.json transformers/transform_data.jq
	./transformers/transform_data.jq "$<" > "$@"

build/%.png: plots/% build/data_2.tsv
	gnuplot -e "filename='build/data_2.tsv'" "$<" > "$@"

# build/ratio_pain.png: transformer/ratio_pain data

# watch:
# > echo .

# exclude:
# > echo .DS_Store
# > echo .git/
# > echo zit/.git/
# > echo zit/\.zit/
# > echo build/
# > echo zit/zit$$
