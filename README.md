# INCEPTION
Learning about Dockers, Containers, and Volumes!
_This project has been created as part of the 42 curriculum by rpadasia [@madametussaudsgaming]_

# Description
This project focuses on the 'Docker' software!__
<ins>DOCKERS AND CONTAINERS</ins>__
DOCKER is a service (not to be confused with a VM) that allows you to build and deliver isolated software in packages called CONTAINERS.

A Container is a type of virtualization (not to be confused with VMs) that operates on the OS level, sharing resources with the host kernel, as opposed to the much heavier Virtual Machine, which simulates its own kernel. (Though this project is typically done within a Virtual Machine.)  A container simply has all necessary dependencies packaged with it, built from an a Docker IMAGE. A good comparison is to a python virtual environment (venv), but on a filesystem's scale.

Taking all this into account, many individual containers can run simulaneously, taking up MBs as opposed to GBs of space (both RAM and Disk Space). Packaging your software with the EXACT dependencies it was developed with (Python version, Linux version etc), a server can run containers with entirely different versions of the same dependency, with no problem caused for each other! These containers also can share memory with each other as they store data in VOLUMES on the host OS.

That being said, Mac and Windows will use a hypervisor like VirtualBox to run our containers, making these implementations functionally OS-agnostic, provided there is a Linux-based hypervisor.


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