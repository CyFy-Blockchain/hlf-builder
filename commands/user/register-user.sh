## External Params
USER_NAME=$1
USER_PWD=$2
RCA_HOST_NAME=$3
RCA_PORT=$4

# path variables
CURRENT_FILE_PATH=$(dirname "$(realpath "$0")")
ROOT_DIR=$(realpath "$CURRENT_FILE_PATH/../../")

## Global params
BIN_CLIENT=$(realpath "$ROOT_DIR/bin")/fabric-ca-client

# Fabric CA client should know the CA binary path
export FABRIC_CA_CLIENT_HOME=$ROOT_DIR/fabric-ca-client

# Register the user on Org CA
$BIN_CLIENT register -d --id.name $USER_NAME --id.secret $USER_PWD -u https://$RCA_HOST_NAME:$RCA_PORT --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir tls-ca/rcaadmin/msp
