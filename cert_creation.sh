#!/bin/bash

DOMAIN=$1

if [ -z "$1" ]; then

    echo "USAGE: $0 domain.lan"
    echo ""
    echo "This will generate a non-secure self-signed wildcard certificate for given domain."
    echo "This should only be used in a development environment."
    exit
fi

# Add wildcard
WILDCARD="*.$DOMAIN"

# Set our CSR variables
SUBJ="
C=US
ST=NY
O=
localityName=NewYork
commonName=$WILDCARD
organizationalUnitName=
emailAddress=snakesonda@gmail.com
"
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -out "$DOMAIN.crt" -keyout "$DOMAIN.key" -subj "/CN=${WILDCARD}/O=${DOMAIN}"
