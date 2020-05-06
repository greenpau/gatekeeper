.PHONY: build clean test
APP_VERSION:=$(shell cat VERSION | head -1)
GIT_COMMIT:=$(shell git describe --dirty --always)
GIT_BRANCH:=$(shell git rev-parse --abbrev-ref HEAD -- | head -1)
BUILD_USER:=$(shell whoami)
BUILD_DATE:=$(shell date +"%Y-%m-%d")
BINARY:="gatekeeper"
VERBOSE:=-v
GRP_NAME="gatekeeper"
USR_NAME="gatekeeper"


all: build

clean:
	@rm -rf bin/

build:
	@echo "Version: $(APP_VERSION), Branch: $(GIT_BRANCH), Revision: $(GIT_COMMIT)"
	@echo "Build on $(BUILD_DATE) by $(BUILD_USER)"
	@mkdir -p bin/
	@go get -u github.com/caddyserver/xcaddy/cmd/xcaddy
	@xcaddy build v2.0.0 --output bin/$(BINARY) \
		--with github.com/greenpau/caddy-auth-saml@v1.1.10  \
		--with github.com/greenpau/caddy-auth-jwt@v0.0.13
	@echo "Done!"

test:
	@bin/$(BINARY) -conf /etc/gatekeeper/Caddyfile

install:
	@sudo groupadd --system $(GRP_NAME) || true
	@sudo useradd --system -d /var/lib/%{name} -s /bin/bash -g $(GRP_NAME) $(USR_NAME) || true
	@sudo mkdir -p /var/{lib,log}/$(BINARY)
	@sudo mkdir -p /etc/$(BINARY)
	@sudo rm -rf /var/lib/$(BINARY)/*
	@sudo rm -rf /etc/sysconfig/$(BINARY).conf
	@sudo cp -R assets/www/* /var/lib/$(BINARY)/
	@cat assets/conf/sysconfig_$(BINARY).conf | sudo tee /etc/sysconfig/$(BINARY).conf
	@cat assets/conf/systemd_$(BINARY).service | sudo tee /usr/lib/systemd/system/$(BINARY).service
	@sudo chown -R $(GRP_NAME):$(USR_NAME) /var/{lib,log}/$(BINARY)
	@sudo chown -R $(GRP_NAME):$(USR_NAME) /etc/$(BINARY)
	@#sudo systemctl enable $(BINARY)
	@#sudo systemctl start $(BINARY)
	@#sudo systemctl status $(BINARY)
