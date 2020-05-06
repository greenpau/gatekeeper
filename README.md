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

Additionally, download the following UI elements:

```bash
sudo wget -O /etc/gatekeeper/ui/saml_login.template https://raw.githubusercontent.com/greenpau/caddy-auth-ui/master/assets/templates/saml_login.template
sudo wget -O /etc/gatekeeper/ui/forms_login.template https://raw.githubusercontent.com/greenpau/caddy-auth-ui/master/assets/templates/forms_login.template
sudo wget -O /etc/gatekeeper/ui/forms_portal.template https://raw.githubusercontent.com/greenpau/caddy-auth-ui/master/assets/templates/forms_portal.template
sudo chown -R gatekeeper:gatekeeper /etc/gatekeeper/
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
