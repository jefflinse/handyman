all: clean build test

source_files = *.go */*.go */*/*.go
coverage_profile = coverage.out
coverage_report = coverage.report.out
compiler_bin = tools/compiler/compiler
runner_bin = tools/runner/runner

clean:
	go clean -i -testcache ./...
	rm -f $(coverage_profile) $(coverage_report)

build: $(compiler_bin) $(runner_bin)

test: $(coverage_profile)

coverage: $(coverage_report)
	cat $(coverage_report)

coverage-html: $(coverage_profile)
	go tool cover -html=$(coverage_profile)

$(compiler_bin): $(source_files)
	go build ./...
	cd tools/compiler && go build

$(runner_bin): $(source_files)
	go build ./...
	cd tools/runner && go build

$(coverage_report): $(coverage_profile)
	go tool cover -func=$(coverage_profile) > $(coverage_report)

$(coverage_profile): $(source_files)
	go test -tags test -coverprofile=$(coverage_profile) -race ./...

