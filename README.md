# HLF-BUILDER

This repository contains the configuration and scripts to set up a Hyperledger Fabric Network. You can run these scripts to deploy the entire Hyperledger Fabric Network at once.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Setup Instructions](#setup-instructions)
- [Usage](#usage)
- [Cleaning Up](#cleaning-up)
- [Contributing](#contributing)
- [License](#license)

## Overview

HLF-BUILDER is a comprehensive toolkit designed to simplify the deployment and management of a Hyperledger Fabric network. It includes all necessary configurations and scripts to set up Certificate Authorities (CAs), orderers, peers, and channels.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- Docker and Docker Compose installed
- Bash shell
- Hyperledger Fabric binaries

## Setup Instructions

1. **Clone the repository:**

   ```sh
   git clone <repository-url>
   cd <repository-directory>
   ```

2. **Start the Certificate Authorities:**

   ```sh
   docker-compose -f 1-compose-ca.yaml up -d
   docker-compose -f 5-compose-orderer-ca.yaml up -d
   ```

3. **Enroll the CA admin:**

   ```sh
   ./2-enroll-admin.sh
   ```

4. **Register and enroll the peer user:**

   ```sh
   ./3-register-peer-user.sh
   ```

5. **Register and enroll the orderer user:**

   ```sh
   ./6-register-orderer-user.sh
   ```

6. **Start the network:**

   ```sh
   docker-compose -f 4-compose-test-net.yaml up -d
   docker-compose -f 7-compose-orderer.yaml up -d
   ```

7. **Create the channel:**
   ```sh
   ./8-create-channel.sh
   ```

## Usage

After setting up the network, you can interact with it using the Hyperledger Fabric CLI tools. Refer to the Hyperledger Fabric documentation for detailed usage instructions.

## Cleaning Up

To clean up the project and remove all generated files and containers, run:

```sh
./0-cleanup.sh
```

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

## License

This project is licensed under the Apache 2.0 License.
