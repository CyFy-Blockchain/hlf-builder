# HLF-Builder

This Repo is responsible for creating and maintaining HLF components that are required for the Blockchain ecosystem. This Repo contains code that run in a sequential fashion as per the [document](https://hyperledger-fabric-ca.readthedocs.io/en/latest).

## Setup

Firstly, go to [github](https://github.com/hyperledger/fabric-ca/releases), and download the binaries for CA server and client that are supported as per your architecture.
Now, create a directory on root level, `bin` and keep your binaries in this directory.

## Running the code

#### ⚠️ Make sure you have followed the setup first

1. Run `npm install`
2. Go to `src/index.ts`. It contains a step-by-step guide to setup the network for HLF. Here are the steps:
   a. Create a TLS server
   b. Enroll a TLS admin through the Fabric client
   c. Register and enroll a root CA admin through the Fabric client with TLS server
   d. Create a CA server
   e. Enroll a CA admin with the server
