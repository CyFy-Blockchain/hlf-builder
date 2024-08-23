## External Params
NODE_IDENTIFIER=$1
ORG_NAME=$2

# path variables
CURRENT_FILE_PATH=$(dirname "$(realpath "$0")")
ROOT_DIR=$(realpath "$CURRENT_FILE_PATH/../../")
# Peer path
PEER_PATH=$ROOT_DIR/fabric-ca-client/$ORG_NAME/peer/$NODE_IDENTIFIER
TLS_CA_SERVER_PATH=$ROOT_DIR/fabric-ca-server-tls/

# Copy the tls root file to the peer directory
cp $TLS_CA_SERVER_PATH/ca-cert.pem $PEER_PATH/tls-ca-cert.pem

# Copy the peer config in the peer directory
cp $ROOT_DIR/fabric-config/core.yaml $PEER_PATH/core.yaml

# Update the name of tls private key to peer-key.pem
mv "$PEER_PATH/tls/msp/keystore/$(ls -t "$PEER_PATH/tls/msp/keystore" | head -n 1)" $PEER_PATH/tls/msp/keystore/peer-key.pem

# Update the FABRIC_CFG_PATH to core.yaml
export FABRIC_CFG_PATH=$PEER_PATH/core.yaml
