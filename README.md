# gatekeeper

Gatekeeper is password-protected Caddy-based reverse proxy server for
access in Prometheus and Alertmanager.

## Getting Started

First, install `gatekeeper`:

```bash
git clone https://github.com/greenpau/gatekeeper.git
cd gatekeeper
make install
```

Next, start `gatekeeper` service:

```bash
sudo systemctl enable gatekeeper
sudo systemctl start gatekeeper
sudo systemctl status gatekeeper
```
