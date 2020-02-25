module github.com/greenpau/gatekeeper

go 1.13

require (
	github.com/BTBurke/caddy-jwt v3.7.1+incompatible
	github.com/caddyserver/caddy v1.0.4
	github.com/crewjam/saml v0.4.0
	github.com/tarent/loginsrv v1.3.1
)

//replace github.com/crewjam/saml v0.4.0 => /home/greenpau/dev/go/src/github.com/crewjam/saml
//replace github.com/tarent/loginsrv v1.3.1 => /home/greenpau/dev/go/src/github.com/tarent/loginsrv
replace github.com/crewjam/saml v0.4.0 => ../../crewjam/saml

replace github.com/tarent/loginsrv v1.3.1 => ../../tarent/loginsrv
