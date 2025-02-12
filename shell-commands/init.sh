ROOTDIR=$(cd "$(dirname "$0")" && pwd)
# push to the required directory & set a trap to go back if needed
pushd ${ROOTDIR} >/dev/null
trap "popd > /dev/null" EXIT

# Initial imports from the trapped directory
. config/default.sh
. config/network-config.sh
. helpers/utils.sh
. services/network.sh

# Setups for exporting Fabric Path
export PATH=${ROOTDIR}/../bin:${PWD}/../bin:$PATH
export FABRIC_CFG_PATH=${PWD}/configtx
export VERBOSE=false

# Setups for docker & docker-compose commands
: ${CONTAINER_CLI:="docker"}
if command -v ${CONTAINER_CLI}-compose >/dev/null 2>&1; then
    : ${CONTAINER_CLI_COMPOSE:="${CONTAINER_CLI}-compose"}
else
    : ${CONTAINER_CLI_COMPOSE:="${CONTAINER_CLI} compose"}
fi
infoln "Using ${CONTAINER_CLI} and ${CONTAINER_CLI_COMPOSE}"

# Setting up the network
infoln "Starting nodes with CLI timeout of '${MAX_RETRY}' tries and CLI delay of '${CLI_DELAY}' seconds and using database '${DATABASE}'"
networkUp $CONTAINER_CLI $COMPOSE_FILE_BASE # imported from services/network.sh
