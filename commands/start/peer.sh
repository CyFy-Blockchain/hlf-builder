## External Params
NODE_IDENTIFIER=$1
ORG_NAME=$2

# Path configurations
CURRENT_FILE_PATH=$(dirname "$(realpath "$0")")
ROOT_DIR=$(realpath "$CURRENT_FILE_PATH/../../")
PEER_PATH=$ROOT_DIR/fabric-ca-client/$ORG_NAME/peer/$NODE_IDENTIFIER

## Global params
BIN_PEER=$(realpath "$ROOT_DIR/bin")/peer

cd $PEER_PATH

$BIN_PEER node start
