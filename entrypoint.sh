#!/bin/sh

# Create required directories if they don’t exist
mkdir -p /etc/hyperledger/fabric-ca-server/msp/keystore
mkdir -p /etc/hyperledger/fabric-ca-server/tls

# Start Fabric CA Server in the background
fabric-ca-server start -b admin:adminpw -d &

# Wait for a few seconds to ensure the server initializes
sleep 10

# Log the CA certificate
echo "------ CA CERTIFICATE (ca-cert.pem) ------"
cat /etc/hyperledger/fabric-ca-server/ca-cert.pem
echo "------------------------------------------"

# List all files in keystore
echo "------ FILES IN KEYSTORE ------"
ls -l /etc/hyperledger/fabric-ca-server/msp/keystore/
echo "--------------------------------"

# Find and log the private key file name
PRIVATE_KEY_FILE=$(ls /etc/hyperledger/fabric-ca-server/msp/keystore/ | grep '_sk')
if [ -f "/etc/hyperledger/fabric-ca-server/msp/keystore/$PRIVATE_KEY_FILE" ]; then
    echo "------ PRIVATE KEY FILE ($PRIVATE_KEY_FILE) ------"
    cat /etc/hyperledger/fabric-ca-server/msp/keystore/$PRIVATE_KEY_FILE
    echo "-------------------------------------------------"
else
    echo "ERROR: Private key not found in keystore!"
fi

# Keep the container running
wait
