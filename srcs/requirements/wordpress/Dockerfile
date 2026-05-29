#base image
FROM debian:trixie

#execute command in terminal of container
RUN apt-get -y update && apt-get -y upgrade && apt update -y && apt upgrade -y \
	apt install php-fpm \
	apt install php-mysql \
	apt install curl

#copy and authorize script into the image
COPY tools/script.sh /usr/local/bin/wordpress_init.sh
RUN chmod +x /usr/local/bin/wordpress_init.sh

#run the script when container starts
ENTRYPOINT ["wordpress_init.sh"]

