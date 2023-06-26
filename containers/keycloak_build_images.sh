#!/bin/bash

DNS=jarry.dk
ROOT_FOLDER=/etc/letsencrypt/live
if [ ! -d $ROOT_FOLDER ]; then
    echo "Change ROOT_FOLDER to $HOME/certs"
    ROOT_FOLDER=$HOME/certs
fi
FULLCHAIN_PEM_PATH=$ROOT_FOLDER/$DNS/fullchain.pem
PRIVKEY_PEM_PATH=$ROOT_FOLDER/$DNS/privkey.pem

function get-certs() {
    if [ ! -d "$DNS" ]; then
        mkdir $DNS
    fi
    if [ -f "$FULLCHAIN_PEM_PATH" ]; then
        cp -v $FULLCHAIN_PEM_PATH $DNS/fullchain.pem
        chown 1000:1000 $DNS/fullchain.pem
    fi
    if [ -f "$PRIVKEY_PEM_PATH" ]; then
        cp -v $PRIVKEY_PEM_PATH $DNS/privkey.pem
        chown 1000:1000 $DNS/privkey.pem
    fi
}

function house-keeping-certs() {
    rm -vrf $DNS
}

printf "\033[32mGet certs from secure place\033[39m\n"
get-certs

printf "\n\033[32mBuild image\033[39m\n"
podman build . -f keycloak-Dockerfile -t jarrydk/keycloak

printf "\n\033[32mRemove certs from insecure place\033[39m\n"
trap house-keeping-certs EXIT
