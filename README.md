# Full Node

This project sets up a minimal Bitcoin full node with the maximum privacy.

- Bitcoin Full Node
- Uses Knots for spam prevention
- Enforces Tor for outgoing connections
- Enforces Tor for incoming connections
- Acts as a Tor relayer to help the Tor network
- Uses Alpine Linux for a lightweight image
- Disabled GUI for faster startup
- Compiled from source for optimized binary

Images build time: 7m 45s
Images size: 81.8MB + 37.7MB

## First time setup instructions

1. Install Docker and Docker Compose on your system:
    - [Docker installation guide](https://docs.docker.com/get-docker/)
    - [Docker Compose installation guide](https://docs.docker.com/compose/install/)

2. Create directories for persistent storage:
   - for Knots to store the blockchain (e.g., `/mnt/hdd/knots`)
   - for Tor to store its data (e.g., `/var/lib/tor`)

3. Set ownership and permissions of the directories:
   Ensure that the directories are owned by specific user and group IDs that will be used in the Docker containers. For example:
    ```bash
    drwxr-x--- 6 1001 1001 4096 Jan  3 00:42 knots
    drwxr-x--- 4 1002 1002 4096 Jan  3 00:42 tor
    ```

4. Update the `.env` file with the correct paths and user/group IDs

5. Build the Docker images:
   ```bash
   docker-compose build
   ```

## Run the services

- Start:
   ```bash
   docker-compose up -d
   ```

- Stop:
   ```bash
    docker-compose down
    ```

more information about the available docker-compose commands can be found in the [docker-compose documentation](https://docs.docker.com/reference/cli/docker/compose/).

## Access the block explorer

#TODO: mempool explorer service