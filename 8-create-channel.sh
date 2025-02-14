#!/bin/bash

CHANNEL_NAME="$1"
DELAY="$2"
MAX_RETRY="$3"
VERBOSE="$4"
BFT="$5"
: ${CHANNEL_NAME:="mychannel"}
: ${DELAY:="3"}
: ${MAX_RETRY:="5"}
: ${VERBOSE:="false"}
: ${BFT:=0}

# Local variables
PEER0_ORG1_CA="$PWD/organizations/peerOrganizations/org1.deployment.com/tlsca/tlsca.org1.deployment.com-cert.pem"
PEER0_MSPCONFIGPATH="$PWD/organizations/peerOrganizations/org1.deployment.com/msp"
PEER0_HOST_PORT="localhost:7153"

if [ ! -d "channel-artifacts" ]; then
    mkdir channel-artifacts
fi

# Set Configurations
setPeerConfigs() {
    export CORE_PEER_LOCALMSPID="Org1DeploymentMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=$PEER0_MSPCONFIGPATH
    export CORE_PEER_ADDRESS=$PEER0_HOST_PORT
}
setOrdererConfigsAndJoinChannel() {
    export ORDERER_CA=${PWD}/organizations/ordererOrganizations/deployment.com/tlsca/tlsca.deployment.com-cert.pem
    export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/organizations/ordererOrganizations/deployment.com/orderers/orderer.deployment.com/tls/server.crt
    export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/organizations/ordererOrganizations/deployment.com/orderers/orderer.deployment.com/tls/server.key
    ./bin/osnadmin channel join --channelID ${CHANNEL_NAME} --config-block ./channel-artifacts/${CHANNEL_NAME}.block -o localhost:7063 --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY" >>log.txt 2>&1
}

verifyResult() {
    if [ $1 -ne 0 ]; then
        echo "$2"
    fi
}

createChannelGenesisBlock() {
    setPeerConfigs
    ./bin/configtxgen -profile GenesisProfile -outputBlock ./channel-artifacts/${CHANNEL_NAME}.block -channelID $CHANNEL_NAME
    res=$?
    verifyResult $res "Failed to generate channel configuration transaction..."
}

createChannel() {
    # Poll in case the raft leader is not set yet
    local rc=1
    local COUNTER=1
    echo "Adding orderers"
    while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ]; do
        sleep $DELAY
        set -x
        setOrdererConfigsAndJoinChannel
        res=$?
        { set +x; } 2>/dev/null
        let rc=$res
        COUNTER=$(expr $COUNTER + 1)
    done
    cat log.txt
    verifyResult $res "Channel creation failed"
}

# joinChannel ORG
joinChannel() {
    ORG=$1
    FABRIC_CFG_PATH=$PWD/../config/
    setGlobals $ORG
    local rc=1
    local COUNTER=1
    ## Sometimes Join takes time, hence retry
    while [ $rc -ne 0 -a $COUNTER -lt $MAX_RETRY ]; do
        sleep $DELAY
        set -x
        peer channel join -b $BLOCKFILE >&log.txt
        res=$?
        { set +x; } 2>/dev/null
        let rc=$res
        COUNTER=$(expr $COUNTER + 1)
    done
    cat log.txt
    verifyResult $res "After $MAX_RETRY attempts, peer0.org${ORG} has failed to join channel '$CHANNEL_NAME' "
}

setAnchorPeer() {
    ORG=$1
    . scripts/setAnchorPeer.sh $ORG $CHANNEL_NAME
}

## User attempts to use BFT orderer in Fabric network with CA
if [ $BFT -eq 1 ] && [ -d "organizations/fabric-ca/ordererOrg/msp" ]; then
    fatalln "Fabric network seems to be using CA. This sample does not yet support the use of consensus type BFT and CA together."
fi

## Create channel genesis block
BLOCKFILE="./channel-artifacts/${CHANNEL_NAME}.block"

echo "Generating channel genesis block '${CHANNEL_NAME}.block'"
export FABRIC_CFG_PATH=${PWD}/configtx

createChannelGenesisBlock

## Create channel
echo "Creating channel ${CHANNEL_NAME}"
createChannel
echo "Channel '$CHANNEL_NAME' created"

# ## Join all the peers to the channel
# echo "Joining org1 peer to the channel..."
# joinChannel 1
# echo "Joining org2 peer to the channel..."
# joinChannel 2

# ## Set the anchor peers for each org in the channel
# echo "Setting anchor peer for org1..."
# setAnchorPeer 1
# echo "Setting anchor peer for org2..."
# setAnchorPeer 2

# successln "Channel '$CHANNEL_NAME' joined"
