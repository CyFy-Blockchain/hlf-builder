#!/bin/sh

# Create required directories if they don’t exist
mkdir -p /etc/hyperledger/fabric-ca-server/msp
mkdir -p /etc/hyperledger/fabric-ca-server/tls

# Start Fabric CA Server in the background
fabric-ca-server start -b admin:adminpw -d &

# Wait for a few seconds to ensure the server initializes
sleep 5

# Log the CA certificate content to Render logs
echo "------ CA CERTIFICATE ------"
cat /etc/hyperledger/fabric-ca-server/ca-cert.pem
echo "----------------------------"

# Keep the container running
wait
