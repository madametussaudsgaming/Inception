# INCEPTION
Learning about Dockers, Containers, and Volumes!
_This project has been created as part of the 42 curriculum by rpadasia [@madametussaudsgaming]_
<ins>Contents</ins><br />
- Description
- Instructions
- Useful Commands
- Resources

# Description
This project focuses on the 'Docker' software!<br /><br />

<ins>DOCKERS AND CONTAINERS</ins><br />
DOCKER is a service (not to be confused with a VM) that allows you to build and deliver isolated software in packages called CONTAINERS.

A Container is a type of virtualization (not to be confused with VMs) that operates on the OS level, sharing resources with the host kernel, as opposed to the much heavier Virtual Machine, which simulates its own kernel. (Though this project is typically done within a Virtual Machine.)  A container simply has all necessary dependencies packaged with it, built from an a Docker IMAGE. A good comparison is to a python virtual environment (venv), but on a filesystem's scale.

Taking all this into account, many individual containers can run simulaneously, taking up MBs as opposed to GBs of storage. Packaging your software with the exact dependencies it was developed with (Python version, Linux version etc), a server can run containers with entirely different versions of the same dependency, with no problem caused for each other! These containers also can share memory with each other as they store data in VOLUMES on the host OS.

That being said, Mac and Windows will use a hypervisor like VirtualBox to run our containers, making these implementations functionally OS-agnostic, provided there is a Linux-based hypervisor.

<ins>DOCKERS ENGINE</ins><br />
This is what allows you to bundle your application and its dependencies into containers! It also includes the Docker Daemon, the background process managing the containers, as well as the Docker Client, used in the terminal to interact with the Daemon.

<ins>DOCKERFILE</ins><br />
The Dockerfile is a plaintext file with all the instructions needed to build a Docker IMAGE. It typically contains a base image to use, all dependencies to install, and scipts needed to set up the environment. The Image is a package containing all the dependencies (code, libraries) needed to run a software. You use 'docker build' on the Dockerfile, with the Daemon creating an builds the image, you then use 'docker run', and the Daemon creates a container from said image.

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