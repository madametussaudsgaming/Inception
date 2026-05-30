#base image
FROM debian:bookworm

#execute command in terminal of container
RUN apt-get -y update && apt-get -y upgrade && apt update -y && apt upgrade -y \
	apt-get install php-fpm \
	apt-get install php-mysql \
	apt-get install curl
#NOTES
#apt-get is typically for scripts and automation, while apt is for interactive use
#will literally print warning if using regular apt for scripts

#copy and authorize script into the image
COPY tools/script.sh /usr/local/bin/wordpress_init.sh
RUN chmod +x /usr/local/bin/wordpress_init.sh

#run the script when container starts
ENTRYPOINT ["wordpress_init.sh"]

