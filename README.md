# Bitcoin Full Node

This project sets up a minimal Bitcoin full node with the maximum privacy.

- **Full** blockchain state
- Uses **Knots** to fight the spam
- Enforces **Tor** for all connections
- Acts as **Tor Relay** to help the Tor network
- Uses **Alpine Linux** for lightweight images
- **Compiled** from source for optimized binary
- GPG **Signature verification** for all components

Images size:
- Knots: 89.7MB
- Tor client: 20.2MB
- Tor relay: 20.4MB

## First time setup instructions

1. Install Docker and Docker Compose on your system:
    - [Docker installation guide](https://docs.docker.com/engine/install/)
    - [Docker Compose installation guide](https://docs.docker.com/compose/install/standalone)

2. Edit the `.env` file:
```
# directories where persistent data will be stored
KNOTS_DATA=/mnt/hdd/bitcoin/knots
TOR_DATA=/var/lib/bitcoin/tor

# user ID that owns the data directories, will be used to run the containers
UID=1000

# your host machine public IP address, used by Tor to advertise the service
HOST_PUBLIC_IP=87.19.107.144

# RPC credentials for Knots
RPC_USER=your_rpc_user
RPC_PASSWORD=your_rpc_password

# Tor control credentials used internally
TOR_CONTROL_PASSWORD=your_tor_control_password
TOR_CONTROL_HASHED_PASSWORD=16:ADDBD7CF108C995F60F831F115BA5EB95322FC4645433CDEB8948A57DF
```

WARNING: *if you already have tor installed on your system, make sure that your TOR_DATA directory is not the same as the one already used by your system tor installation. One is used inside the containers, the other is used by your system tor service.*

3. Build the Docker images:
   ```bash
   docker-compose build
   ```

## Run the services

```bash
docker-compose up -d   # Start
docker-compose down    # Stop
```

NOTE: *Docker automatically stops and restarts containers on system reboot.*

more information about the available docker-compose commands can be found in the [docker-compose documentation](https://docs.docker.com/reference/cli/docker/compose/).

## Accessing the node

The node is now listening for RPC connections on port `8332` of the host machine. You can interact with it using the `bitcoin-cli` command, software wallets, mempool explorers, or any other Core/Knots RPC compatible client.