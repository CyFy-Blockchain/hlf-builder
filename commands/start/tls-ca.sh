CURRENT_FILE_PATH=$(dirname "$(realpath "$0")")
ROOT_DIR=$(realpath "$CURRENT_FILE_PATH/../../")
BIN_SERVER=$(realpath "$ROOT_DIR/bin")/fabric-ca-server

cd $ROOT_DIR/fabric-ca-server-tls

rm -rf ./msp ./ca-cert.pem
$BIN_SERVER start
