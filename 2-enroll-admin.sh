# function enrollAdmin() {
#     echo "Enrolling the CA admin"
#     mkdir -p organizations/peerOrganizations/org1.deployment.com/

#     export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org1.deployment.com/

#     set -x
#     bin/fabric-ca-client enroll -u https://admin:adminpw@localhost:7055 --caname ca-org1-deployment --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem"
#     { set +x; } 2>/dev/null
# }

# enrollAdmin

function enrollAdmin() {
    echo "Enrolling the CA admin"

    mkdir -p organizations/peerOrganizations/org1.deployment.com/

    export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org1.deployment.com/

    # Define the Render deployment CA URL (remove protocol for safer handling)
    FABRIC_CA_SERVER_DOMAIN="hlf-builder.onrender.com:7055"

    echo "Using CA Server URL: $FABRIC_CA_SERVER_DOMAIN"

    set -x
    bin/fabric-ca-client enroll -u https://admin:adminpw@$FABRIC_CA_SERVER_DOMAIN --caname ca-org1-deployment --tls.certfiles "${PWD}/organizations/fabric-ca/org1/ca-cert.pem"
    { set +x; } 2>/dev/null
}

enrollAdmin

