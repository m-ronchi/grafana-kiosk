CCARMV7=arm-linux-gnueabihf-gcc
CCARM64=aarch64-linux-gnu-gcc

all: grafana-kiosk
	@echo "Building"

dev:
	@echo "Building grafana-kiosk"
	GOOS=darwin GOARCH=amd64 go build -o bin/grafana-kiosk.darwin pkg/cmd/grafana-kiosk/main.go

grafana-kiosk: dev
	@echo "Building grafana-kiosk"
	mkdir -p bin
	GOOS=linux GOARCH=amd64 go build -o bin/grafana-kiosk.linux.amd64 pkg/cmd/grafana-kiosk/main.go
	GOOS=linux GOARCH=386 go build -o bin/grafana-kiosk.linux.386 pkg/cmd/grafana-kiosk/main.go
	GOOS=linux GOARCH=arm GOARM=5 go build -o bin/grafana-kiosk.linux.armv5 pkg/cmd/grafana-kiosk/main.go
	GOOS=linux GOARCH=arm GOARM=6 go build -o bin/grafana-kiosk.linux.armv6 pkg/cmd/grafana-kiosk/main.go
	GOOS=linux GOARCH=arm GOARM=7 go build -o bin/grafana-kiosk.linux.armv7 pkg/cmd/grafana-kiosk/main.go
	GOOS=linux GOARCH=arm64 go build -o bin/grafana-kiosk.linux.arm64 pkg/cmd/grafana-kiosk/main.go

test-circleci:
	@echo "Testing build in circleci"
	circleci local execute --job cmd-lint
	circleci local execute --job build

package: grafana-kiosk
	@echo "Packaging"

release: package
	@echo "Release"
