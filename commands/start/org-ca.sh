CURRENT_FILE_PATH=$(dirname "$(realpath "$0")")
ROOT_DIR=$(realpath "$CURRENT_FILE_PATH/../../")
BIN_SERVER=$(realpath "$ROOT_DIR/bin")/fabric-ca-server

cd $ROOT_DIR/fabric-ca-server

# delete ca-cert.pem
rm ./ca-cert.pem
rm -rf ./msp

# start fabric-ca-server
$BIN_SERVER start
