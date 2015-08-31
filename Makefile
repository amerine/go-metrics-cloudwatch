GO_PACKAGES := $(shell go list ./... | sed 's_github.com/sclasen/go-metrics-cloudwatch_._')


all: ready test

travis: tidy test

install: godep
	 godep go install ./...

forego:
	go get github.com/ddollar/forego

godep:
	go get github.com/tools/godep

test: install
	godep go test ./...

test-aws: install forego
	forego run godep go test

tidy:
	go get golang.org/x/tools/cmd/goimports
	test -z "$$(goimports -l -d $(GO_PACKAGES) | tee /dev/stderr)"

lint:
	test -z "$$(golint ./... | tee /dev/stderr)"
	go vet ./...


imports:
	go get github.com/golang/lint/golint
	goimports -w .

fmt:
	go fmt ./...

ready: fmt imports tidy
