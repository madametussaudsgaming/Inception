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

Taking all this into account, many individual containers can run simulaneously, taking up MBs as opposed to GBs of storage. Packaging your software with the exact dependencies it was developed with (Python version, Linux version etc), a server can run containers with entirely different versions of the same dependency, with no problem caused for each other! These containers also can share memory with each other as they store data in VOLUMES on the host OS.

That being said, Mac and Windows will use a hypervisor like VirtualBox to run our containers, making these implementations functionally OS-agnostic, provided there is a Linux-based hypervisor.

<ins>DOCKERS ENGINE</ins><br />
This is what allows you to bundle your application and its dependencies into containers! It also includes the Docker Daemon, the background process managing the containers, as well as the Docker Client, used in the terminal to interact with the Daemon.

<ins>DOCKERFILE</ins><br />
The Dockerfile is a plaintext file with all the instructions needed to build a Docker IMAGE. It typically contains a base image to use, all dependencies to install, and scipts needed to set up the environment. The Image is a package containing all the dependencies (code, libraries) needed to run a software. You run 'docker build' on the Dockerfile, with the Daemon building the image, you then use 'docker run', and the Daemon creates a container from said image.

<ins>DOCKER-COMPOSE</ins><br />
Written in YAML (a configuration language), this file defines how multiple Docker containers will be set up and run, acting as a kind of conductor for what volume directories, networks and services are a part of the full application, immediate breaks and activation of all container systems.

<ins>DOCKER NETWORK</ins><br />
Virtual software that connects the Docker containers, allowing them to communicate with each other and the outside world. I use the default BRIDGE network, containers attached to it can talk to each other using their container/service names as hostnames. It's also isolated from the host so the containers can only be reached externally through explicitly stated ports (in my case, nginx can be reached through port 443). To have a host network would mean to share the host machine's network stack directly; a process listening to port, say, 1234 would also be directly accessible on the host's port 1234. This is bad for us, as the isolation offers

<ins>DOCKER VOLUMES</ins><br />
Simply put, it is a persistent storage location used to store data from and between containers, persisting even after its container is deleted. There are two kinds:
- the Bind Mount, which mounts inside a container's isolated file system, connecting it to a storage source outside the container. When you bind mount, you're referencing a specific absolute path on the host machine, like rpadasia/myproject/data.
That means if deployed on a different machine, the path breaks. This will NOT be the case in
- the Docker Volume, which is stored in an unspecified location on the host machine, referenced by a name (eg. "app-data") for the Engine to figure out where it would live on the host. Much better for shared volumes!

<ins>NEED TO KNOW</ins><br />
Secrets VS. Environmental Variables - ENVs are plain text values typically filled with macro definitions for programs to use, while Secrets are encrypted, only mounted into containers that explicitly request them, only readable by root inside the container. This is significantly more secure as the raw credentials are never found or exposed in the repository.

Now onto the types of containers we will need to build!

<ins>MariaDB</ins><br />



# Instructions
1. Set up a Linux VM (I've used Debian), no large explanation necessary here. Enable bi-directional clipbord for your own sanity.
2.
# Resources

A Project description section (to be added) must also explain the use of Docker and the sources
included in the project. It must indicate the main design choices, as well as a
comparison between:
◦ Virtual Machines vs Docker
◦ Secrets vs Environment Variables
◦ Docker Network vs Host Network
◦ Docker Volumes vs Bind Mount

# Resources
Dockers, Containers and other Key Concepts -
Docker Compose -
Dockerfile -
Volumes -
WordPress -
MariaDB -
NGINX -
Scripting -
'Default' Config References -