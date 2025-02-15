# Use the official Hyperledger Fabric CA image
FROM hyperledger/fabric-ca:latest

# Set the working directory
WORKDIR /etc/hyperledger/fabric-ca-server

# Copy configuration files (optional, if needed)
# COPY fabric-ca-server-config.yaml /etc/hyperledger/fabric-ca-server/

# Set environment variables
ENV FABRIC_CA_HOME=/etc/hyperledger/fabric-ca-server
ENV FABRIC_CA_SERVER_CA_NAME=ca-org1-deployment
ENV FABRIC_CA_SERVER_TLS_ENABLED=true
ENV FABRIC_CA_SERVER_PORT=7055
ENV FABRIC_CA_SERVER_DB_TYPE=sqlite3

# Expose the Fabric CA port
EXPOSE 7055

# Start the Fabric CA server
CMD ["fabric-ca-server", "start", "-b", "admin:adminpw"]
