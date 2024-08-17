# # External params
CA_ADMIN_USER=$1
CA_ADMIN_PASS=$2

# # Root directory
CURRENT_FILE_PATH=$(dirname "$(realpath "$0")")
ROOT_DIR=$(realpath "$CURRENT_FILE_PATH/../../")

# ## Global params
BIN_SERVER=$(realpath "$ROOT_DIR/bin")/fabric-ca-server

# # Create a structure for org CA
mkdir $ROOT_DIR/fabric-ca-server

# Change the name of they keystore file in TLS root ca msp to key.pem

# Give CA server access to the TLS crypto materials of the root ca admin
cd $ROOT_DIR/fabric-ca-server
mkdir tls
cp ../fabric-ca-client/tls-ca/rcaadmin/msp/signcerts/cert.pem tls
cp "$ROOT_DIR/fabric-ca-client/tls-ca/rcaadmin/msp/keystore/$(ls -t "$ROOT_DIR/fabric-ca-client/tls-ca/rcaadmin/msp/keystore" | head -n 1)" tls/key.pem

# Init the CA server
$BIN_SERVER init -b $CA_ADMIN_USER:$CA_ADMIN_PASS
