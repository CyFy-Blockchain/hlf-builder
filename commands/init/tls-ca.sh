## External Params
# Admin credentials
ADMIN_USER=$1
ADMIN_PWD=$2
ORG_NAME=$3

# Root directory
CURRENT_FILE_PATH=$(dirname "$(realpath "$0")")
ROOT_DIR=$(realpath "$CURRENT_FILE_PATH/../../")

## Global params
BIN_SERVER=$(realpath "$ROOT_DIR/bin")/fabric-ca-server

# Create TLS structure
cd $ROOT_DIR
mkdir fabric-ca-server-tls

# Init TLS CA server
cd fabric-ca-server-tls
$BIN_SERVER init -b $ADMIN_USER:$ADMIN_PWD
