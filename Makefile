# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: kdchain android ios kdchain-cross swarm evm all test clean
.PHONY: kdchain-linux kdchain-linux-386 kdchain-linux-amd64 kdchain-linux-mips64 kdchain-linux-mips64le
.PHONY: kdchain-linux-arm kdchain-linux-arm-5 kdchain-linux-arm-6 kdchain-linux-arm-7 kdchain-linux-arm64
.PHONY: kdchain-darwin kdchain-darwin-386 kdchain-darwin-amd64
.PHONY: kdchain-windows kdchain-windows-386 kdchain-windows-amd64

GOBIN = $(shell pwd)/build/bin
GO ?= latest

kdchain:
	build/env.sh go run build/ci.go install ./cmd/kdchain
	@echo "Done building."
	@echo "Run \"$(GOBIN)/kdchain\" to launch kdchain."

swarm:
	build/env.sh go run build/ci.go install ./cmd/swarm
	@echo "Done building."
	@echo "Run \"$(GOBIN)/swarm\" to launch swarm."

all:
	build/env.sh go run build/ci.go install

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/kdchain.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/Gkdchain.framework\" to use the library."

test: all
	build/env.sh go run build/ci.go test

lint: ## Run linters.
	build/env.sh go run build/ci.go lint

clean:
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/kevinburke/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go get -u github.com/golang/protobuf/protoc-gen-go
	env GOBIN= go install ./cmd/abigen
	@type "npm" 2> /dev/null || echo 'Please install node.js and npm'
	@type "solc" 2> /dev/null || echo 'Please install solc'
	@type "protoc" 2> /dev/null || echo 'Please install protoc'

# Cross Compilation Targets (xgo)

kdchain-cross: kdchain-linux kdchain-darwin kdchain-windows kdchain-android kdchain-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/kdchain-*

kdchain-linux: kdchain-linux-386 kdchain-linux-amd64 kdchain-linux-arm kdchain-linux-mips64 kdchain-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/kdchain-linux-*

kdchain-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/kdchain
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/kdchain-linux-* | grep 386

kdchain-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/kdchain
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/kdchain-linux-* | grep amd64

kdchain-linux-arm: kdchain-linux-arm-5 kdchain-linux-arm-6 kdchain-linux-arm-7 kdchain-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/kdchain-linux-* | grep arm

kdchain-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/kdchain
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/kdchain-linux-* | grep arm-5

kdchain-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/kdchain
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/kdchain-linux-* | grep arm-6

kdchain-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/kdchain
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/kdchain-linux-* | grep arm-7

kdchain-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/kdchain
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/kdchain-linux-* | grep arm64

kdchain-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/kdchain
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/kdchain-linux-* | grep mips

kdchain-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/kdchain
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/kdchain-linux-* | grep mipsle

kdchain-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/kdchain
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/kdchain-linux-* | grep mips64

kdchain-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/kdchain
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/kdchain-linux-* | grep mips64le

kdchain-darwin: kdchain-darwin-386 kdchain-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/kdchain-darwin-*

kdchain-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/kdchain
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/kdchain-darwin-* | grep 386

kdchain-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/kdchain
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/kdchain-darwin-* | grep amd64

kdchain-windows: kdchain-windows-386 kdchain-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/kdchain-windows-*

kdchain-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/kdchain
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/kdchain-windows-* | grep 386

kdchain-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/kdchain
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/kdchain-windows-* | grep amd64
