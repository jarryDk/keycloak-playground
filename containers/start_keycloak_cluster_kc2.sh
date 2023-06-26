#!/bin/bash

source ./config.conf

printf "\033[32m--------------------------------------------------------\033[39m\n"
printf "\033[32mKeycloak starting                                       \033[39m\n"
printf "\033[32m    container name is keycloak-playground-cluster-kc2   \033[39m\n"
printf "\033[32m    internal network $PODMAN_NETWORK                    \033[39m\n"
printf "\033[32m--------------------------------------------------------\033[39m\n"
printf "\033[32mKC_DB_URL=jdbc:postgresql://$POSTGRES_KEYCLOAK_DNS_NAME/$POSTGRES_KEYCLOAK_USER\033[39m\n"
printf "\033[32m--------------------------------------------------------\033[39m\n"

podman run \
    -d \
    --name keycloak-playground-cluster-kc2 \
    --network=$PODMAN_NETWORK \
    -e KEYCLOAK_ADMIN=$KEYCLOAK_ADMIN \
    -e KEYCLOAK_ADMIN_PASSWORD=$KEYCLOAK_ADMIN_PASSWORD \
    -e KC_DB_URL=jdbc:postgresql://$POSTGRES_KEYCLOAK_DNS_NAME/$POSTGRES_KEYCLOAK_USER \
    -e KC_DB_USERNAME=$POSTGRES_KEYCLOAK_USER \
    -e KC_DB_PASSWORD=$POSTGRES_KEYCLOAK_PASSWORD \
    -e KC_HOSTNAME_PORT=8443 \
    -e KC_PROXY=edge \
    -e KC_HOSTNAME_STRICT=false \
    jarrydk/keycloak \
    start --optimized
