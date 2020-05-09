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

version:
	@echo "Version: $(APP_VERSION), Branch: $(GIT_BRANCH), Revision: $(GIT_COMMIT)"
	@echo "Build on $(BUILD_DATE) by $(BUILD_USER)"

build-dir:
	@mkdir -p bin/


build: version build-dir
	@xcaddy build v2.0.0 --output bin/$(BINARY) \
		--with github.com/greenpau/caddy-auth-saml@v1.1.10 \
		--with github.com/greenpau/caddy-auth-forms@v0.0.5 \
		--with github.com/greenpau/caddy-auth-jwt@v0.0.13

build-forms: version build-dir
	@xcaddy build v2.0.0 --output bin/$(BINARY)-forms \
		--with github.com/greenpau/caddy-auth-forms@v0.0.5 \
		--with github.com/greenpau/caddy-auth-jwt@v0.0.13

test: version
	@./bin/$(BINARY) validate -config assets/conf/Caddyfile.json

test-forms:
	@./bin/$(BINARY)-forms validate -config assets/conf/Caddyfile_forms.json

dep:
	@go get -u github.com/caddyserver/xcaddy/cmd/xcaddy

install:
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
