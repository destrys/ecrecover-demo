#
# == Paths & Directories ==
#

ROOT_DIR  := $(shell pwd)
NODE_DIR  := $(ROOT_DIR)/node_modules

#
# == Configuration ==
#

GANACHE_PORT ?= 8545
DAPP_PORT    ?= 8435


#
# == Commands ==
#

NPM        := npm
NODE       := node
TRUFFLE    := $(NODE_DIR)/.bin/truffle
GANACHE    := $(NODE_DIR)/.bin/ganache-cli

#
# == Top-Level Targets ==
#

default: compile

dependencies: js-dependencies

compile:
	$(TRUFFLE) compile

freeze:
	$(NPM) shrinkwrap

clean:
	rm -rf build/*

purge: clean
	rm -rf $(NODE_DIR)

js-dependencies:
	npm install

test:
	./scripts/test

.PHONY: test compile
