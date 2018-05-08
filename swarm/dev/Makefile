.PHONY: build cluster test

default: build

build:
	go build -o bin/swarm    github.com/kdchain/go-kdchain/cmd/swarm
	go build -o bin/gkdchain     github.com/kdchain/go-kdchain/cmd/gkdchain
	go build -o bin/bootnode github.com/kdchain/go-kdchain/cmd/bootnode

cluster: build
	scripts/boot-cluster.sh

test:
	go test -v github.com/kdchain/go-kdchain/swarm/...
