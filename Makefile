.PHONY: dev setup build install test release clean

CGO_ENABLED=0
VERSION=$(shell git describe --abbrev=0 --tags)
COMMIT=$(shell git rev-parse --short HEAD)

all: dev

dev: build
	@./tube -v

setup:
	@go get github.com/GeertJohan/go.rice/rice

build: clean
	@go generate $(shell go list)/...
	@go build \
		-tags "netgo static_build" -installsuffix netgo \
		-ldflags "-w -X $(shell go list).Version=$(VERSION) -X $(shell go list).Commit=$(COMMIT)" \
		.

install: build
	@go install

test: install
	@go test

release:
	@./tools/release.sh

clean:
	@git clean -f -d -X
