#!/bin/bash

source ./config.conf

printf "\033[32m----------------------------------------------------\033[39m\n"
printf "\033[32mPostgreSQL starting                                 \033[39m\n"
printf "\033[32m    listing on port 5462 on the host                \033[39m\n"
printf "\033[32m    container name is $POSTGRES_KEYCLOAK_HOST       \033[39m\n"
printf "\033[32m    internal network $PODMAN_NETWORK           \033[39m\n"
printf "\033[32m----------------------------------------------------\033[39m\n"

if [ -z $POSTGRES_KEYCLOAK_DATA_FOLDER ]; then
    podman run \
        -d \
        --name $POSTGRES_KEYCLOAK_HOST \
        --network=$PODMAN_NETWORK \
        -e POSTGRES_USER=$POSTGRES_KEYCLOAK_USER \
        -e POSTGRES_PASSWORD=$POSTGRES_KEYCLOAK_PASSWORD \
        -e POSTGRES_DB=$POSTGRES_KEYCLOAK_DB \
        -p $POSTGRES_KEYCLOAK_PORT:5432 \
        postgres:15
else
    printf "\033[32m    datafolder is $POSTGRES_KEYCLOAK_DATA_FOLDER \033[39m\n"
    printf "\033[32m----------------------------------------------------\033[39m\n"
    if [ ! -d $POSTGRES_KEYCLOAK_DATA_FOLDER ]; then
        mkdir -p $POSTGRES_KEYCLOAK_DATA_FOLDER
        podman unshare chown $POSTGRES_KEYCLOAK_DATA_FOLDER_OWNER -R $POSTGRES_KEYCLOAK_DATA_FOLDER
    fi
    podman run \
        -d \
        --name $POSTGRES_KEYCLOAK_HOST \
        --network=$PODMAN_NETWORK \
        -v $POSTGRES_KEYCLOAK_DATA_FOLDER:/var/lib/postgresql/data:Z \
        -e POSTGRES_USER=$POSTGRES_KEYCLOAK_USER \
        -e POSTGRES_PASSWORD=$POSTGRES_KEYCLOAK_PASSWORD \
        -e POSTGRES_DB=$POSTGRES_KEYCLOAK_DB \
        -p $POSTGRES_KEYCLOAK_PORT:5432 \
        postgres:15
fi