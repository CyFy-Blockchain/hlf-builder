## External Params
ADMIN_USER=$1
ADMIN_PWD=$2
ORG_NAME=$3
HOST_NAME=$4
PORT=$5

CA_ADMIN_USER=$6
CA_ADMIN_PWD=$6

# path variables
CURRENT_FILE_PATH=$(dirname "$(realpath "$0")")
ROOT_DIR=$(realpath "$CURRENT_FILE_PATH/../../")
TLS_CA_SERVER_PATH=$ROOT_DIR/fabric-ca-server-tls

## Global params
BIN_CLIENT=$(realpath "$ROOT_DIR/bin")/fabric-ca-client

## Create client structure
mkdir fabric-ca-client
cd fabric-ca-client
mkdir tls-ca $ORG_NAME-ca int-ca tls-root-cert

# Copy tls certificate to client
cp $TLS_CA_SERVER_PATH/ca-cert.pem ./tls-root-cert/tls-ca-cert.pem

# Fabric CA client should know the CA binary path
export FABRIC_CA_CLIENT_HOME=$ROOT_DIR/fabric-ca-client

# Enroll the TLS admin, that was registered at the time of creation
$BIN_CLIENT enroll -d -u https://$ADMIN_USER:$ADMIN_PWD@$HOST_NAME:$PORT --tls.certfiles tls-root-cert/tls-ca-cert.pem --enrollment.profile tls --mspdir tls-ca/tlsadmin/msp

# Register the CA admin
$BIN_CLIENT register -d --id.name $CA_ADMIN_USER --id.secret $CA_ADMIN_PWD -u https://$HOST_NAME:$PORT --tls.certfiles tls-root-cert/tls-ca-cert.pem --mspdir tls-ca/tlsadmin/msp

# Enroll the CA admin
$BIN_CLIENT enroll -d -u https://$CA_ADMIN_USER:$CA_ADMIN_PWD@$HOST_NAME:$PORT --tls.certfiles tls-root-cert/tls-ca-cert.pem --enrollment.profile tls --csr.hosts 'localhost' --mspdir tls-ca/rcaadmin/msp
