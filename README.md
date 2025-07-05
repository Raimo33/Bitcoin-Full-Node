# Full Node

This project sets up a minimal Bitcoin full node with the maximum privacy.

- **Full** blockchain state
- Uses **Knots** to fight the spam
- Enforces **Tor** for all connections
- Acts as **Tor Relay** to help the Tor network
- Uses **Alpine Linux** for lightweight images
- **Compiled** from source for optimized binary
- **Signature verification** for all components

#TODO: mempool visualizer
#TODO: monero full node
#TODO: monero CPU miner

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
KNOTS_DIR=/mnt/hdd/knots # Directory where the blockchain will be stored
HOST_PUBLIC_IP=87.19.107.144 # Public IP address of your host (used for Tor relay)

RPC_USER=your_rpc_user # RPC username for Knots
RPC_PASSWORD=your_rpc_password # RPC password for Knots

TOR_CONTROL_PASSWORD=your_tor_control_password # Password for Tor control port
TOR_CONTROL_HASHED_PASSWORD=16:ADDBD7CF108C995F60F831F115BA5EB95322FC4645433CDEB8948A57DF # Generate this using `tor --hash-password your_tor_control_password`
```

5. Build the Docker images:
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

## Access the block explorer

#TODO: mempool explorer service