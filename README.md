# gatekeeper

Gatekeeper is password-protected Caddy-based reverse proxy server for
access in Prometheus and Alertmanager.

## Getting Started

First, build `gatekeeper`:

```bash
git clone https://github.com/greenpau/gatekeeper.git
cd gatekeeper
make build
```

Next, pre-provision the relevant directories:

```bash
make install
```

Then, copy the binary and associated configuration file.

```bash
sudo cp assets/conf/Caddyfile /etc/gatekeeper/Caddyfile
sudo cp bin/gatekeeper /usr/local/bin/gatekeeper
make install
```

Next, start `gatekeeper` service:

```bash
sudo systemctl enable gatekeeper
sudo systemctl start gatekeeper
sudo systemctl status gatekeeper
```

If necessary, troubleshoot:

```bash
sudo systemctl stop gatekeeper
sudo journalctl -u gatekeeper -r --no-pager | more
```
