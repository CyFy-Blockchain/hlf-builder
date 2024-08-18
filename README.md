# HLF-Builder

This Repo is responsible for creating and maintaining HLF components that are required for the Blockchain ecosystem. This Repo contains code that run in a sequential fashion as per the [document](https://hyperledger-fabric-ca.readthedocs.io/en/latest).

## Setup

Firstly, go to [github](https://github.com/hyperledger/fabric-ca/releases), and download the binaries for CA server and client that are supported as per your architecture.
Now, create a directory on root level, `bin` and keep your binaries in this directory.

## Running the code

#### ⚠️ Make sure you have followed the setup first

1. Run `npm install`
2. Review the configurations in the `./src/config` directory for the appropriate configurations
3. Run `npm run up-tls-server` to up the CA TLS server
4. Run `npm run enroll-tls-admin` to enroll the TLS admin
5. Run `npm run up-org-server` to up the CA Org server
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
│   │           │   └── bb9b87a9c1c4dfb4a94e8aa003fe58f10137aaaa1849d20c85a7ad916c769e35_sk
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
