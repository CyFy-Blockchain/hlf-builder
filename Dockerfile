# Use Hyperledger Fabric CA image
FROM hyperledger/fabric-ca:latest

# Set environment variables
ENV FABRIC_CA_HOME=/etc/hyperledger/fabric-ca-server
ENV FABRIC_CA_SERVER_CA_NAME=ca-org1-deployment
ENV FABRIC_CA_SERVER_TLS_ENABLED=true
ENV FABRIC_CA_SERVER_PORT=7055
ENV FABRIC_CA_SERVER_OPERATIONS_LISTENADDRESS=0.0.0.0:17055

# Expose necessary ports
EXPOSE 7055 17055

# Set working directory
WORKDIR /etc/hyperledger/fabric-ca-server

# Ensure the target directory exists before starting the CA server
CMD ["sh", "-c", "mkdir -p /etc/hyperledger/fabric-ca-server && fabric-ca-server start -b admin:adminpw -d"]
