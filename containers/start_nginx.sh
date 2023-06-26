#!/bin/bash

source ./config.conf

printf "\033[32m--------------------------------------------------------\033[39m\n"
printf "\033[nginx starting                                       \033[39m\n"
printf "\033[32m    container name is keycloak-playground-cluster-kc2   \033[39m\n"
printf "\033[32m    internal network $PODMAN_NETWORK                    \033[39m\n"
printf "\033[32m--------------------------------------------------------\033[39m\n"
printf "\033[32mKC_DB_URL=jdbc:postgresql://$POSTGRES_KEYCLOAK_DNS_NAME/$POSTGRES_KEYCLOAK_USER\033[39m\n"
printf "\033[32m--------------------------------------------------------\033[39m\n"

podman run \
    -d \
    --name keycloak-playground-nginx \
    --network=$PODMAN_NETWORK \
    -p 8443:8443 \
    jarrydk/keycloak-nginx
