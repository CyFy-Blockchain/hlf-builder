# HLF-Builder

This Repo is responsible for creating and maintaining HLF components that are required for the Blockchain ecosystem. This Repo contains code that run in a sequential fashion as per the [document](https://hyperledger-fabric-ca.readthedocs.io/en/latest).

## Setup

Firstly, go to [github for CA](https://github.com/hyperledger/fabric-ca/releases), and download the binaries for CA server and client that are supported as per your architecture.
Now, you need binaries for Peer and Orderers. For that, you can download those binaries from [github for Peer & Orderers](https://github.com/hyperledger/fabric/releases).
Now, create a directory on root level, `/bin` and keep your binaries in this directory.

## Running the code

#### ⚠️ Make sure you have followed the setup first

1. Run `npm install`
2. Review the configurations in the `./src/config/default` directory for the appropriate configurations
3. If you're re deploying from scrach, run `npm run reset-repo`
4. Run `npm run up-tls-server` to up the CA TLS server
5. Run `npm run enroll-tls-admin && npm run up-org-server` to enroll the TLS admin, CA admin, and up the server
6. Run `npm run enroll-org-admin` to enroll the Org admin

Running these commands will generate the appropriate crypto materials for the Root CA Admin (rcaadmin), and TLS admin (tlsAdmin)

```bash
.
├── fabric-ca-client
│   ├── UMS-ca
│   │   └── rcaadmin ----> Requried to register any node in Org CA
│   │       └── msp
│   │           ├── cacerts
│   │           │   └── localhost-7054.pem ----> Org CA root certificate
│   │           ├── keystore
│   │           │   └── b6b...9150ca_sk ----> Org CA admin priv key
│   │           └── signcerts
│   │               └── cert.pem ----> Org CA signed Certificate
│   ├── fabric-ca-client-config.yaml
│   ├── tls-ca
│   │   ├── rcaadmin
│   │   │   └── msp
│   │   │       ├── keystore
│   │   │       │   └── 555...3066_sk ----> Priv key of the CA admin for TLS communication
│   │   │       ├── signcerts
│   │   │       │   └── cert.pem ----> Cert of CA admin for TLS communication
│   │   │       └── tlscacerts
│   │   │           └── tls-localhost-7055.pem
│   │   └── tlsadmin ----> Required to register any node in TLS CA
│   │       └── msp
│   │           ├── IssuerPublicKey
│   │           ├── IssuerRevocationPublicKey
│   │           ├── cacerts
│   │           ├── keystore
│   │           │   └── bb9...9e35_sk
│   │           ├── signcerts
│   │           │   └── cert.pem
│   │           ├── tlscacerts
│   │           │   └── tls-localhost-7055.pem
│   │           └── user
│   └── tls-root-cert
│       └── tls-ca-cert.pem ----> Copied cert of Root TLS CA
├── fabric-ca-server
│   ├── msp
│   │   └── keystore
│   │       ├── 513...4672_sk
│   │       └── key.pem ----> Key for BCCSP
│   └── tls ----> For TLS communication
│       ├── cert.pem
│       └── key.pem
└── fabric-ca-server-tls
    ├── ca-cert.pem ----> Cert of Root TLS CA
    ├── msp
    │   ├── cacerts
    │   └── keystore
    │       ├── 355...c2f2_sk
    │       └── b8a...55ec_sk
    └── tls-cert.pem
```

## Enrolling Users

### Node Users - For Peers & Orderers

This section particularly registers and enrolls users for Peers & Orderers. You can then bootstrap these enrolled users to create a Peer / Orderer.

1. Go to `src/config/default.ts` and update the credentials for the `peer` & `orderer`
2. Run `npm run register-node-user` to register the user in the TLS CA, and Org CA

**🚨 It is highly important to register node user in the TLS CA, since they will be communicating with the network**

## Start Peer

To start a new Peer node, follow the following instructions:

1. Go to `src/scripts/start-peer.ts` and place the identifier for the new peer user created. The identifier can be retrieved from the directory name in `src/fabric-ca-client/ORG_NAME/peer/<<IDENTIFIER HERE!!>>`
2. Once you've replaced the correct value for identifier in the `start-peer.ts`, run `npm run start-peer`

## Helper CLI commands

1. You can convert a given cert.pem file into understandable text by using this command `openssl x509 -in /path/to/file/cert.pem -text -noout`
