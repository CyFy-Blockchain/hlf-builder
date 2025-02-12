# import dependencies

# Bring up the peer and orderer nodes using docker compose.
function networkUp() {
    CONTAINER_CLI=$1
    COMPOSE_FILE_BASE=$2

    # generate artifacts if they don't exist
    if [ ! -d "organizations/peerOrganizations" ]; then
        createOrgs
    fi

    # -f compose/compose-test-net.yaml
    COMPOSE_FILES="-f compose/${COMPOSE_FILE_BASE} -f compose/${CONTAINER_CLI}/${CONTAINER_CLI}-${COMPOSE_FILE_BASE}"
    infoln "Compose file command created: ${COMPOSE_FILES}"

    # DOCKER_SOCK="${DOCKER_SOCK}" ${CONTAINER_CLI_COMPOSE} ${COMPOSE_FILES} up -d 2>&1

    # $CONTAINER_CLI ps -a
    # if [ $? -ne 0 ]; then
    #     fatalln "Unable to start network"
    # fi
}
