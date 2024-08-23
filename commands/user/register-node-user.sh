## External Params
USER_NAME=$1
USER_PWD=$2
RCA_HOST_NAME=$3
RCA_PORT=$4
TLS_HOST_NAME=$5
TLS_PORT=$6
ORG_NAME=$7
NODE_TYPE=$8
NODE_IDENTIFIER=$9

# path variables
CURRENT_FILE_PATH=$(dirname "$(realpath "$0")")
ROOT_DIR=$(realpath "$CURRENT_FILE_PATH/../../")

## Global params
BIN_CLIENT=$(realpath "$ROOT_DIR/bin")/fabric-ca-client

# Fabric CA client should know the CA binary path
export FABRIC_CA_CLIENT_HOME=$ROOT_DIR/fabric-ca-client

# Calculate the number of files in the directory
DIRECTORY_PATH=$ROOT_DIR/fabric-ca-client/$ORG_NAME/$NODE_TYPE

# Register the node user in TLS CA
$BIN_CLIENT register -d --id.name $USER_NAME --id.secret $USER_PWD -u https://$TLS_HOST_NAME:$TLS_PORT --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir tls-ca/tlsadmin/msp --id.type $NODE_TYPE
# Enroll the node user in TLS CA
$BIN_CLIENT enroll -d -u https://$USER_NAME:$USER_PWD@$TLS_HOST_NAME:$TLS_PORT --tls.certfiles tls-root-cert/tls-ca-cert.pem --enrollment.profile tls --csr.hosts 'localhost' --mspdir $DIRECTORY_PATH/$NODE_IDENTIFIER/tls/msp

# Register the node user in Org CA
$BIN_CLIENT register -d --id.name $USER_NAME --id.secret $USER_PWD -u https://$RCA_HOST_NAME:$RCA_PORT --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir $ORG_NAME-ca/rcaadmin/msp --id.type $NODE_TYPE
# Enroll the node user in Org CA
$BIN_CLIENT enroll -d -u https://$USER_NAME:$USER_PWD@$RCA_HOST_NAME:$RCA_PORT --tls.certfiles tls-root-cert/tls-ca-cert.pem --enrollment.profile tls --csr.hosts 'localhost' --mspdir $DIRECTORY_PATH/$NODE_IDENTIFIER/ca/msp
