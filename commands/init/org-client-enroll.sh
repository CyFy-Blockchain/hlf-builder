## External Params
CA_ADMIN_USER=$1
CA_ADMIN_PWD=$2
ORG_NAME=$3
HOST_NAME=$4
PORT=$5

# path variables
CURRENT_FILE_PATH=$(dirname "$(realpath "$0")")
ROOT_DIR=$(realpath "$CURRENT_FILE_PATH/../../")

## Global params
BIN_CLIENT=$(realpath "$ROOT_DIR/bin")/fabric-ca-client

# Fabric CA client should know the CA binary path
export FABRIC_CA_CLIENT_HOME=$ROOT_DIR/fabric-ca-client

# Enroll the CA Admin through client in the CA server
$BIN_CLIENT enroll -d -u https://$CA_ADMIN_USER:$CA_ADMIN_PWD@$HOST_NAME:$PORT --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir $ORG_NAME-ca/rcaadmin/msp
