#!/bin/bash

source ./config.conf

printf "\033[32m----------------------------------------------------\033[39m\n"
printf "\033[32mKeycloak starting                                   \033[39m\n"
printf "\033[32m    listing on port $KEYCLOAK_TLS_PORT on the host  \033[39m\n"
printf "\033[32m    container name is $KEYCLOAK_HOST                \033[39m\n"
printf "\033[32m    internal network $PODMAN_NETWORK           \033[39m\n"
printf "\033[32m----------------------------------------------------\033[39m\n"
printf "\033[32mKC_DB_URL=jdbc:postgresql://$POSTGRES_KEYCLOAK_DNS_NAME/$POSTGRES_KEYCLOAK_USER\033[39m\n"
printf "\033[32m----------------------------------------------------\033[39m\n"

podman run \
    -d \
    --name $KEYCLOAK_HOST \
    --network=$PODMAN_NETWORK \
    -p $KEYCLOAK_TLS_PORT:8443 \
    -e KEYCLOAK_ADMIN=$KEYCLOAK_ADMIN \
    -e KEYCLOAK_ADMIN_PASSWORD=$KEYCLOAK_ADMIN_PASSWORD \
    -e KC_DB_URL=jdbc:postgresql://$POSTGRES_KEYCLOAK_DNS_NAME/$POSTGRES_KEYCLOAK_USER \
    -e KC_DB_USERNAME=$POSTGRES_KEYCLOAK_USER \
    -e KC_DB_PASSWORD=$POSTGRES_KEYCLOAK_PASSWORD \
    -e KC_HTTPS_CERTIFICATE_FILE=/opt/keycloak/conf/fullchain.pem \
    -e KC_HTTPS_CERTIFICATE_KEY_FILE=/opt/keycloak/conf/privkey.pem \
    -e KC_HOSTNAME=$KEYCLOAK_DNS_NAME \
    jarrydk/keycloak \
    start --optimized --hostname-port=$KEYCLOAK_TLS_PORT
