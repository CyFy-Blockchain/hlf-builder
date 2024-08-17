CURRENT_FILE_PATH=$(dirname "$(realpath "$0")")
ROOT_DIR=$(realpath "$CURRENT_FILE_PATH/../../")
BIN_SERVER=$(realpath "$ROOT_DIR/bin")/fabric-ca-server

cd $ROOT_DIR/fabric-ca-server

# delete ca-cert.pem
rm ./ca-cert.pem
rm -rf ./msp

# Copy key.pem for Blockchain Crypto Service Provider (BCCSP) in msp/keystore
mkdir -p msp/keystore
cp ./tls/key.pem ./msp/keystore

# start fabric-ca-server
$BIN_SERVER start
