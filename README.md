# Full Node

This project sets up a minimal Bitcoin full node with the maximum privacy.

- Bitcoin **Full Node**
- Uses **Knots** for spam prevention
- Enforces **Tor** for outgoing connections
- Enforces **Tor** for incoming connections
- Uses **Alpine Linux** for a lightweight image
- Compiled from source for optimized binary

Images build time: 7m 45s
Images size: 81.8MB + 37.7MB

## First time setup instructions

1. Install Docker and Docker Compose on your system:
    - [Docker installation guide](https://docs.docker.com/get-docker/)
    - [Docker Compose installation guide](https://docs.docker.com/compose/install/)

2. Create directories for persistent storage:
   - for Knots to store the blockchain (e.g., `/mnt/hdd/knots`)
   - for Tor to store its data (e.g., `/var/lib/full-node/tor`)

  WARNING: *if you already have tor installed in your system, or if you're planning to install a tor client to interact with the full node, beware of not mixing the directories. One is for the tor service inside the container, the other is for the tor service running on your host system.*

3. Set ownership of the directories:
   ```bash
   chown -R 1000:1000 /mnt/hdd/knots
   chown -R 1001:1001 /var/lib/full-node/tor
   ```

4. Update the `.env` file with the correct paths and user/group IDs

5. Edit the `services/knots/bitcoin.conf` file to set your RPC credentials and restrict RPC access to specific IPs.

6. Build the Docker images:
   ```
   docker-compose build
   ```

## Run the services

- Start:
   ```bash
   docker-compose up -d
   ```

- Stop:
   ```
  docker-compose down
  ```

NOTE: *Docker automatically stops and restarts containers on system reboot.*

more information about the available docker-compose commands can be found in the [docker-compose documentation](https://docs.docker.com/reference/cli/docker/compose/).

## Access the block explorer

#TODO: mempool explorer service