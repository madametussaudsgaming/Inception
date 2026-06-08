# INCEPTION
Learning about Dockers, Containers, and Volumes!
_This project has been created as part of the 42 curriculum by rpadasia [@madametussaudsgaming]_
<br /><ins>Contents</ins><br />
- Description
- Instructions
- Useful Commands
- Resources

# Description
This project focuses on the 'Docker' software!<br />

<ins>DOCKERS AND CONTAINERS</ins><br />
DOCKER is a service (not to be confused with a VM) that allows you to build and deliver isolated software in packages called CONTAINERS.

A Container is a type of virtualization (not to be confused with VMs) that operates on the OS level, sharing resources with the host kernel, as opposed to the much heavier Virtual Machine, which simulates its own kernel. (Though this project is typically done within a Virtual Machine.)  A container simply has all necessary dependencies packaged with it, built from an a Docker IMAGE. A good comparison is to a python virtual environment (venv), but on a filesystem's scale.

Taking all this into account, many individual containers can run simulaneously, taking up MBs as opposed to GBs of storage. Packaging your software with the exact dependencies it was developed with (Python version, Linux version etc), a server can run containers with entirely different versions of the same dependency, with no problem caused for each other! These containers also can share data with each other as they store it in VOLUMES on the host OS.

That being said, Mac and Windows's Docker Desktop will use a built-in hypervisor to run our containers, making these implementations functionally OS-agnostic, provided there is a Linux-based hypervisor.

<ins>DOCKERS ENGINE</ins><br />
This is what allows you to bundle your application and its dependencies into containers! It also includes the Docker Daemon, the background process managing the containers, as well as the Docker Client, used in the terminal to interact with the Daemon.

<ins>DOCKERFILE</ins><br />
The Dockerfile is a plaintext file with all the instructions needed to build a Docker IMAGE. It typically contains a base image to use, all dependencies to install, and scipts needed to set up the environment. The Image is a package containing all the dependencies (code, libraries) needed to run a software. You run 'docker build' on the Dockerfile, with the Daemon building the image, you then use 'docker run', and the Daemon creates a container from said image.

<ins>DOCKER-COMPOSE</ins><br />
Written in YAML (a configuration language), this file defines how multiple Docker containers will be set up and run, acting as a kind of conductor for what volume directories, networks and services are a part of the full application, handling the startup, shutdown, and lifecycle of all container systems together.

<ins>DOCKER NETWORK</ins><br />
Virtual software that connects the Docker containers, allowing them to communicate with each other and the outside world. I use the default BRIDGE network, containers attached to it can talk to each other using their container/service names as hostnames. It's also isolated from the host so the containers can only be reached externally through explicitly stated ports (in my case, nginx can be reached through port 443). To have a host network would mean to share the host machine's network stack directly; a process listening to port, say, 1234 would also be directly accessible on the host's port 1234. This is bad for us, as the isolation offers security and prevents unintended access to the host.

<ins>DOCKER VOLUMES</ins><br />
Simply put, it is a persistent storage location used to store data from and between containers, persisting even after its container is deleted. There are two kinds:
- the Bind Mount, which connects a specific absolute path on the host machine directly into the container's isolated filesystem. When you bind mount, you're referencing a specific absolute path on the host machine, like rpadasia/myproject/data. That means if deployed on a different machine, the path breaks. This will NOT be the case in
- the Docker Volume, which is stored in an unspecified location on the host machine, referenced by a name (eg. "app-data") for the Engine to figure out where it would live on the host. Much better for shared volumes!

<ins>NEED TO KNOW</ins><br />
Secrets VS. Environmental Variables - ENVs are plain text values typically filled with macro definitions for programs to use, while Secrets are encrypted, only mounted into containers that explicitly request them, only readable by root inside the container. This is significantly more secure as the raw credentials are never found or exposed in the repository.

CGI - Common Gateway Interfaces! It is an interface specification that enables web servers to execute an external program to process HTTP or HTTPS user requests, featured in the previous WebServ project.

PHP Scripts - Hypertext Preprocessor! Using CGI, they are typically used to dynamically generate HTML code, as well as manage server-side data.

FastCGI - A protocol allowing web servers to communicate with web applications, executes scripts in a more efficient way than traditional CGI protocols, which creates new processes for each script. 'PHP-FPM' implements this protocol specifically for usage with PHP scripts. It has a pool of processes solely responsible for PHP scipt execution, parsing requests, executing and returning results. This is more efficient as these processes can be reused.

TLS - Transport Layer Security, a security protocol used to establish secure communication between two parties over the internet. Uses asymmetric (public key) encryption during the handshake to establish a shared secret, then switches to symmetric encryption for the actual data transfer. Client and server exchange digital certificates and encryption keys to confirm a secure line before communicating.

OpenSSL - An implementation of TLS and its predecessor, SSL. Tool for working with TLS, can manage keys and certificates, configuring the TLS server itself, connecting to as a client, debugging as well as generating digital certificates.

Now onto the types of containers we will need to build!

<ins>MariaDB</ins><br />
An open-source relational database management system; it uses the same keywords and commands as MySQL.

<ins>WordPress</ins><br />
Using PHP and MySQL (MariaDB in our case), it is a platform primarily for building and managing websites without the need for advanced technical skills. Will utilize FastCGI's PHP-FPM.

<ins>Nginx</ins><br />
A web server known for high performance, stability and efficiency. Uses TLS or SSL to handle server-side requests for webapps, can also serve static content, often connected to other software such as databases.

# Instructions
1. Set up a Linux VM (I've used Debian), no large explanation necessary here. Enable bi-directional clipbord for your own sanity. Make sure the user is named your 42 username. Add your domain to '/etc/hosts'.
2. Install Vim, Docker, Docker-Compose.
3. Set up your project directory structure as follows:
    /<br />
••••├── Makefile<br />
••••└── srcs/<br />
••••••••├── .env<br />
••••••••├── docker-compose.yml<br />
••••••••└── requirements/<br />
••••••••••••├── mariadb/<br />
••••••••••••│   ├── Dockerfile<br />
••••••••••••│   └── tools/<br />
••••••••••••│       └── script.sh<br />
••••••••••••├── nginx/<br />
••••••••••••│   ├── Dockerfile<br />
••••••••••••│   ├── conf/<br />
••••••••••••│   │   └── nginx.conf<br />
••••••••••••│   └── tools/<br />
••••••••••••│       └── script.sh<br />
••••••••••••└── wordpress/<br />
••••••••••••••••├── Dockerfile<br />
••••••••••••••••└── tools/<br />
••••••••••••••••└── script.sh<br />
4. Create a .env file for your WordPress and MariaDB containers to use. Add it to .gitignore.
5. Create the Dockerfile for all services. Call 'FROM' with the second-to-latest Debian release. Update and upgrade apt-get, curl and php-fpm. Each follows the same pattern — install packages, copy your script in (preemtively stand ready for its arrival), set ENTRYPOINT (run script when container starts).
6. Write a startup script for all services. They'll run inside the container when it starts. It must end with a foreground process — this is what keeps the container alive. Docker monitors this last process; if it exits, the container shuts down. No 'while true' or 'sleep infinity' nonsense, if the service fails the container should restart, not indefinitely hang. For example, Nginx has a `nginx -g "daemon off;"' mode.
7. Create a docker-compose.yml connecting all three services under one network, with named volumes for persistence. Use `depends_on` to control startup order: MariaDB starts first, then WordPress, then NGINX.
8. Create Makefile, creating the data directories and launching docker compose.

# Useful Commands
Check running containers- "docker ps"<br />
Check logs of container- "docker logs <service>"<br />
Enter a running container's shell- "docker exec -it mariadb bash"<br />
View container network system- "docker network ls"<br />

# Resources
<ins>Dockers, Containers and other Key Concepts</ins><br />
https://docs.docker.com/get-started/overview/<br />
<ins>Docker Compose</ins><br />
https://www.reddit.com/r/docker/comments/1f96g4v/can_someone_please_help_me_understand_how_to_use/<br />
<ins>Dockerfile</ins><br />
https://www.geeksforgeeks.org/cloud-computing/what-is-dockerfile/<br />
https://www.cloudbees.com/blog/what-is-a-dockerfile<br />
https://github.com/Forstman1/inception-42<br />
<ins>Volumes</ins><br />
https://github.com/Forstman1/inception-42<br />
<ins>WordPress</ins><br />
https://github.com/Forstman1/inception-42<br />
<ins>MariaDB</ins><br />
https://github.com/Forstman1/inception-42<br />
<ins>NGINX</ins><br />
https://github.com/Forstman1/inception-42<br />
<ins>'Default' Config References</ins><br />
https://developer.wordpress.org/apis/wp-config-php/<br />
https://mariadb.com/kb/en/configuring-mariadb-with-option-files/<br />
https://wiki.debian.org/nginx<br />

# AI Usage
Claude was used throughout this project as a learning aid to explain concepts including Docker internals, container lifecycle, networking, TLS, FastCGI, shell scripting. All AI-generated explanations were verified for understanding before application. Per the project's AI guidelines, all content used is fully understood and can be justified during peer evaluation.