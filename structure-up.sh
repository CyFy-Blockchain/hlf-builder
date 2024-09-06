# imports
. scripts/utils.sh # imports print helper functions
. scripts/ca.sh    # imports the function to up peers, orderers, and CAs

# External Params
# ORG_NAME=$1
# ADMIN_USERNAME=$2
# ADMIN_PASS=$3
# CA_PORT=$4
# CA_HOST=$5
ORG_NAME='FAST'
ADMIN_USERNAME='admin'
ADMIN_PASS='adminpw'
CA_PORT=7054
CA_HOST='localhost'

DATABASE='leveldb'
CRYPTO='Certificate Authorities'
COMPOSE_FILE_CA=compose-ca.yaml
COMPOSE_FILE_BASE=compose-test-net.yaml

# Get docker sock path from environment variable
SOCK="${DOCKER_HOST:-/var/run/docker.sock}"
DOCKER_SOCK="${SOCK##unix://}"

# Path configurations
ROOTDIR=$(cd "$(dirname "$0")" && pwd)
export PATH=${ROOTDIR}/bin:${PWD}/bin:$PATH
export FABRIC_CFG_PATH=${PWD}/configtx
export VERBOSE=false

# push to the required directory & set a trap to go back if needed
pushd ${ROOTDIR} >/dev/null
trap "popd > /dev/null" EXIT

# Going with docker or docker-compose
: ${CONTAINER_CLI:="docker"}
if command -v ${CONTAINER_CLI}-compose >/dev/null 2>&1; then
    : ${CONTAINER_CLI_COMPOSE:="${CONTAINER_CLI}-compose"}
else
    : ${CONTAINER_CLI_COMPOSE:="${CONTAINER_CLI} compose"}
fi
infoln "Using ${CONTAINER_CLI} and ${CONTAINER_CLI_COMPOSE}"

# Versions of fabric known not to work with the test network
NONWORKING_VERSIONS="^1\.0\. ^1\.1\. ^1\.2\. ^1\.3\. ^1\.4\."

# Do some basic sanity checking to make sure that the appropriate versions of fabric
# binaries/images are available. In the future, additional checking for the presence
# of go or other items could be added.
function checkPrereqs() {
    ## Check if your have cloned the peer binaries and configuration files.
    peer version >/dev/null 2>&1

    if [[ $? -ne 0 || ! -d "./config" ]]; then
        errorln "Peer binary and configuration files not found.."
        errorln
        errorln "Follow the instructions in the Fabric docs to install the Fabric Binaries:"
        errorln "https://hyperledger-fabric.readthedocs.io/en/latest/install.html"
        exit 1
    fi
    # use the fabric peer container to see if the samples and binaries match your
    # docker images
    LOCAL_VERSION=$(peer version | sed -ne 's/^ Version: //p')
    DOCKER_IMAGE_VERSION=$(${CONTAINER_CLI} run --rm hyperledger/fabric-peer:latest peer version | sed -ne 's/^ Version: //p')

    infoln "LOCAL_VERSION=$LOCAL_VERSION"
    infoln "DOCKER_IMAGE_VERSION=$DOCKER_IMAGE_VERSION"

    if [ "$LOCAL_VERSION" != "$DOCKER_IMAGE_VERSION" ]; then
        warnln "Local fabric binaries and docker images are out of  sync. This may cause problems."
    fi

    for UNSUPPORTED_VERSION in $NONWORKING_VERSIONS; do
        infoln "$LOCAL_VERSION" | grep -q $UNSUPPORTED_VERSION
        if [ $? -eq 0 ]; then
            fatalln "Local Fabric binary version of $LOCAL_VERSION does not match the versions supported by the test network."
        fi

        infoln "$DOCKER_IMAGE_VERSION" | grep -q $UNSUPPORTED_VERSION
        if [ $? -eq 0 ]; then
            fatalln "Fabric Docker image version of $DOCKER_IMAGE_VERSION does not match the versions supported by the test network."
        fi
    done

    ## check for cfssl binaries
    if [ "$CRYPTO" == "cfssl" ]; then

        cfssl version >/dev/null 2>&1
        if [[ $? -ne 0 ]]; then
            errorln "cfssl binary not found.."
            errorln
            errorln "Follow the instructions to install the cfssl and cfssljson binaries:"
            errorln "https://github.com/cloudflare/cfssl#installation"
            exit 1
        fi
    fi

    ## Check for fabric-ca
    if [ "$CRYPTO" == "Certificate Authorities" ]; then

        fabric-ca-client version >/dev/null 2>&1
        if [[ $? -ne 0 ]]; then
            errorln "fabric-ca-client binary not found.."
            errorln
            errorln "Follow the instructions in the Fabric docs to install the Fabric Binaries:"
            errorln "https://hyperledger-fabric.readthedocs.io/en/latest/install.html"
            exit 1
        fi
        CA_LOCAL_VERSION=$(fabric-ca-client version | sed -ne 's/ Version: //p')
        CA_DOCKER_IMAGE_VERSION=$(${CONTAINER_CLI} run --rm hyperledger/fabric-ca:latest fabric-ca-client version | sed -ne 's/ Version: //p' | head -1)
        infoln "CA_LOCAL_VERSION=$CA_LOCAL_VERSION"
        infoln "CA_DOCKER_IMAGE_VERSION=$CA_DOCKER_IMAGE_VERSION"

        if [ "$CA_LOCAL_VERSION" != "$CA_DOCKER_IMAGE_VERSION" ]; then
            warnln "Local fabric-ca binaries and docker images are out of sync. This may cause problems."
        fi
    fi
}

# Create Organization crypto material using cryptogen or CAs
function createOrg() {
    if [ -d "organizations/peerOrganizations" ]; then
        rm -Rf organizations/peerOrganizations && rm -Rf organizations/ordererOrganizations
    fi

    # Create crypto material using Fabric CA
    if [ "$CRYPTO" == "Certificate Authorities" ]; then
        infoln "Generating certificates using Fabric CA"
        COMMAND="${CONTAINER_CLI_COMPOSE} -f compose/$COMPOSE_FILE_CA up"
        echo $COMMAND
        # Creates the tls-cert.pem file - docker-compose -f compose/compose-ca.yaml -f compose/docker-compose-ca.yaml up -d 2>&1
        ${CONTAINER_CLI_COMPOSE} -f compose/$COMPOSE_FILE_CA up -d 2>&1

        # Guide: https://hyperledger-fabric-ca.readthedocs.io/en/latest/deployguide/cadeploy.html#:~:text=Copy%20the%20TLS%20CA%20root%20certificate%20file%20fabric%2Dca%2Dserver%2Dtls/ca%2Dcert.pem
        while :; do
            if [ ! -f "organizations/fabric-ca/$ORG_NAME/tls-cert.pem" ]; then
                sleep 1
            else
                break
            fi
        done

        infoln "Creating $ORG_NAME Identities"

        createOrganisation $ORG_NAME $ADMIN_USERNAME $ADMIN_PASS $CA_PORT $CA_HOST

    fi

    infoln "Generating CCP files for Org1 and Org2"
    ./organizations/ccp-generate.sh
}

# Bring up the peer and orderer nodes using docker compose.
function networkUp() {

    checkPrereqs

    # generate artifacts if they don't exist
    if [ ! -d "organizations/peerOrganizations" ]; then
        createOrg
    fi

    # -f compose/compose-test-net.yaml
    COMPOSE_FILES="-f compose/${COMPOSE_FILE_BASE} -f compose/${CONTAINER_CLI}/${CONTAINER_CLI}-${COMPOSE_FILE_BASE}"

    if [ "${DATABASE}" == "couchdb" ]; then
        COMPOSE_FILES="${COMPOSE_FILES} -f compose/${COMPOSE_FILE_COUCH} -f compose/${CONTAINER_CLI}/${CONTAINER_CLI}-${COMPOSE_FILE_COUCH}"
    fi

    DOCKER_SOCK="${DOCKER_SOCK}" ${CONTAINER_CLI_COMPOSE} ${COMPOSE_FILES} up -d 2>&1

    $CONTAINER_CLI ps -a
    if [ $? -ne 0 ]; then
        fatalln "Unable to start network"
    fi
}

infoln "Starting nodes with CLI timeout of '${MAX_RETRY}' tries and CLI delay of '${CLI_DELAY}' seconds and using database '${DATABASE}' ${CRYPTO_MODE}"
networkUp
