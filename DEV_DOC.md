# DEV_DOC.md — Developer Documentation
_Inception project by rpadasia_

---

## Setting up the environment from scratch

### Prerequisites

- A Linux Virtual Machine running **Debian Bookworm** (second-to-latest stable Debian, as required by the project)
- VirtualBox with NAT network adapter
- Your VM username must match your 42 login (`rpadasia`) because volume paths are tied to `/home/rpadasia/data`

### 1. Configure the VM network

Set VirtualBox network to NAT, then add your domain to the VM's hosts file:

```bash
sudo nano /etc/hosts
```

Add this line (do NOT remove or modify the existing localhost line):
```
127.0.0.1   rpadasia.42.fr
```

### 2. Install Docker and Docker Compose

Debian's default repositories have an outdated Docker. Use Docker's official repository:

```bash
sudo apt-get install -y ca-certificates curl gnupg

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

Add your user to the docker group to avoid needing sudo for every command:

```bash
sudo usermod -aG docker $USER
# Log out and back in for this to take effect
```

If after a reboot you get a socket permission error (`permission denied at /var/run/docker.sock`), run:

```bash
sudo chmod 666 /var/run/docker.sock
```

### 3. Project directory structure

The project must follow this exact structure:

```
/
├── Makefile
├── secrets/                        ← optional, for Docker secrets
│   ├── db_password.txt
│   └── db_root_password.txt
└── srcs/
    ├── .env                        ← environment variables, never commit to git
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   └── tools/
        │       └── script.sh
        ├── nginx/
        │   ├── Dockerfile
        │   ├── conf/
        │   │   └── nginx.conf
        │   └── tools/
        │       └── script.sh
        └── wordpress/
            ├── Dockerfile
            └── tools/
                └── script.sh
```

### 4. Configuration files

**`.env` file** at `srcs/.env` — picked up automatically by Docker Compose. Must be added to `.gitignore`. Contains all credentials and configuration values used by the container startup scripts:

```bash
# Domain
DOMAIN_NAME=rpadasia.42.fr

# MariaDB
db1_name=wordpressdb
db1_user=rpadasia
db1_pwd=yourpassword

# WordPress
WP_TITLE=MySite
WP_ADMIN_USR=rpadasia_super      # must NOT contain the word 'admin'
WP_ADMIN_PWD=yourpassword
WP_ADMIN_EMAIL=you@student.42.fr
WP_USR=rpadasia_user
WP_PWD=yourpassword
WP_EMAIL=user@rpadasia.42.fr
```

**`.gitignore`** at project root — must include:
```
srcs/.env
secrets/
```

### 5. How each service is built

Each service follows the same Dockerfile pattern:

```dockerfile
FROM debian:bookworm                          # penultimate stable Debian, never 'latest'
RUN apt-get update && apt-get install -y ...  # install packages
COPY ./conf/file /path/in/container           # copy config files
COPY ./tools/script.sh /usr/local/bin/init.sh # copy startup script
RUN chmod +x /usr/local/bin/init.sh           # make executable
ENTRYPOINT ["/usr/local/bin/init.sh"]         # run on container start
```

Key rules:
- Never use the `latest` tag on base images
- Never put passwords in Dockerfiles — use `.env` via `env_file` in docker-compose
- Each service has exactly one Dockerfile and one startup script
- The startup script must end with the service running **in the foreground** (not daemonized), as Docker monitors the last launched process — if it exits, the container shuts down

### 6. Service-specific notes

**MariaDB script** flow:
1. Change `bind-address` from `127.0.0.1` to `0.0.0.0` so other containers can connect
2. Start MariaDB temporarily (`service mysql start`)
3. Run SQL to create the database, user, and set root password
4. Kill the temporary instance
5. Start `mysqld` in the foreground (keeps container alive)

**WordPress script** flow:
1. Create `/var/www/html` and navigate into it
2. Download and install WP-CLI
3. Download WordPress core files
4. Rename `wp-config-sample.php` to `wp-config.php`
5. Use `sed` to replace placeholder values with real credentials from `.env`
6. Replace `localhost` with `mariadb` in the config (containers find each other by service name)
7. Install WordPress, create admin account, create second user
8. Configure PHP-FPM to listen on port 9000 instead of a Unix socket (required for cross-container communication)
9. Start PHP-FPM in the foreground with `-F` flag

**NGINX script** flow:
1. Generate a self-signed TLS certificate with OpenSSL
2. Start NGINX in the foreground with `nginx -g "daemon off;"`

---

## Building and launching the project

```bash
make
```

This runs:
```makefile
mkdir -p /home/rpadasia/data/mariadb
mkdir -p /home/rpadasia/data/wordpress
docker compose -f srcs/docker-compose.yml up -d --build
```

The `--build` flag forces Docker to rebuild images from Dockerfiles every time. The `-d` flag runs containers in detached (background) mode.

Docker Compose starts containers in this order due to `depends_on`:
```
MariaDB → WordPress → NGINX
```

Note: `depends_on` only waits for the container to *start*, not for the service inside to be *ready*. If WordPress tries to connect to MariaDB before it finishes initializing, it may fail. This is a known timing issue — if WordPress fails on first run, a clean rebuild usually fixes it:

```bash
make clean && make
```

---

## Managing containers and volumes

### Viewing container status
```bash
docker ps                    # running containers
docker ps -a                 # all containers including stopped
```

### Viewing logs
```bash
docker logs mariadb
docker logs wordpress
docker logs nginx
docker logs -f nginx         # follow logs in real time
```

### Entering a container shell
```bash
docker exec -it mariadb bash
docker exec -it wordpress bash
docker exec -it nginx bash
```

### Stopping and starting
```bash
make down                    # stop containers, keep volumes and images
make clean                   # stop and remove everything
make                         # rebuild and start fresh
```

### Manual Docker Compose commands
```bash
docker compose -f srcs/docker-compose.yml up -d --build   # start
docker compose -f srcs/docker-compose.yml down             # stop
docker compose -f srcs/docker-compose.yml down -v          # stop + remove volumes
docker compose -f srcs/docker-compose.yml logs             # view all logs
```

### Managing images
```bash
docker images                # list all images
docker rmi nginx:1.0         # remove a specific image
docker rmi $(docker images -q) # remove all images
```

### Managing volumes
```bash
docker volume ls             # list all volumes
docker volume inspect wordpress  # inspect a volume
docker volume rm wordpress   # remove a volume (container must be stopped)
```

---

## Where data is stored and how it persists

### Volume locations

Both named volumes store their data on the host VM at:

```
/home/rpadasia/data/
    mariadb/      ← all MariaDB database files
    wordpress/    ← all WordPress site files
```

These paths are configured in `docker-compose.yml` under `driver_opts`:

```yaml
volumes:
  wordpress:
    driver: local
    driver_opts:
      device: /home/rpadasia/data/wordpress
      o: bind
      type: none
  mariadb:
    driver: local
    driver_opts:
      device: /home/rpadasia/data/mariadb
      o: bind
      type: none
```

### How persistence works

- **MariaDB volume** mounted at `/var/lib/mysql` inside the container — this is where MariaDB stores all database files. When the container is destroyed and recreated, MariaDB finds its existing data here and does not reinitialize.

- **WordPress volume** mounted at `/var/www/html` inside both the WordPress and NGINX containers — WordPress writes its files here, NGINX reads from here to serve them. Both containers see the same files via the shared volume.

### What survives a `make down`

Everything — volumes are untouched by `make down`. Your WordPress posts, database, users and settings all persist.

### What does NOT survive a `make clean`

`make clean` runs `docker compose down -v` which removes the volumes along with containers and images. All data in `/home/rpadasia/data/` is deleted. This is a full reset — WordPress will be reinstalled from scratch on the next `make`.
