.PHONY: build clean test
APP_VERSION:=$(shell cat VERSION | head -1)
GIT_COMMIT:=$(shell git describe --dirty --always)
GIT_BRANCH:=$(shell git rev-parse --abbrev-ref HEAD -- | head -1)
BUILD_USER:=$(shell whoami)
BUILD_DATE:=$(shell date +"%Y-%m-%d")
BUILD_DIR:=$(shell pwd)
BINARY:="gatekeeper"
VERBOSE:=-v
GRP_NAME="gatekeeper"
USR_NAME="gatekeeper"
CADDY_VERSION="v2.1.1"
CADDY_AUTH_VERSION="v1.0.7"


all: build

clean:
	@rm -rf bin/

version:
	@echo "Version: $(APP_VERSION), Branch: $(GIT_BRANCH), Revision: $(GIT_COMMIT)"
	@echo "Build on $(BUILD_DATE) by $(BUILD_USER)"

build-dir:
	@mkdir -p bin/


build: version build-dir
	@xcaddy build $(CADDY_VERSION) --output bin/$(BINARY) \
		--with github.com/greenpau/caddy-auth@$(CADDY_AUTH_VERSION)

localbuild: version build-dir
	@rm -rf ./bin/caddy
	@rm -rf ../xcaddy-$(BINARY)/*
	@mkdir -p ../xcaddy-$(BINARY)/ && cd ../xcaddy-$(BINARY)/ && \
		xcaddy build $(CADDY_VERSION) --output ../$(BINARY)/bin/$(BINARY) \
		--with github.com/greenpau/caddy-auth@latest=$(BUILD_DIR)/../caddy-auth \
		--with github.com/greenpau/caddy-auth-portal@latest=$(BUILD_DIR)/../caddy-auth-portal \
		--with github.com/greenpau/caddy-auth-jwt@latest=$(BUILD_DIR)/../caddy-auth-jwt

test: version
	@./bin/$(BINARY) validate -config assets/conf/config.json

dep:
	@go get -u github.com/caddyserver/xcaddy/cmd/xcaddy

install:
	@sudo cp ./bin/$(BINARY) /usr/local/bin/gatekeeper
	@sudo groupadd --system $(GRP_NAME) || true
	@sudo useradd --system -d /var/lib/%{name} -s /bin/bash -g $(GRP_NAME) $(USR_NAME) || true
	@sudo mkdir -p /var/{lib,log}/$(BINARY)
	@sudo mkdir -p /etc/$(BINARY)
	@sudo rm -rf /var/lib/$(BINARY)/*
	@sudo rm -rf /etc/sysconfig/$(BINARY).conf
	@cat assets/conf/sysconfig_$(BINARY).conf | sudo tee /etc/sysconfig/$(BINARY).conf
	@cat assets/conf/systemd_$(BINARY).service | sudo tee /usr/lib/systemd/system/$(BINARY).service
	@sudo mkdir -p /etc/gatekeeper/auth/jwt/
	@sudo mkdir -p /etc/gatekeeper/auth/local/
	@sudo mkdir -p /etc/gatekeeper/auth/saml/
	@sudo mkdir -p /etc/gatekeeper/tls/
	@sudo mkdir -p /etc/gatekeeper/ui/
	@sudo chown -R $(GRP_NAME):$(USR_NAME) /etc/$(BINARY)
	@sudo chown -R $(GRP_NAME):$(USR_NAME) /var/{lib,log}/$(BINARY)
	@echo "If necessary, run the following commands:"
	@echo "  sudo systemctl daemon-reload"
	@echo "  sudo systemctl enable $(BINARY)"
	@echo "  sudo systemctl start $(BINARY)"
	@echo "  sudo systemctl status $(BINARY)"
