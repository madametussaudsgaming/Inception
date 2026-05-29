FROM debian:trixie


RUN apt-get update && apt-get install y \
	php-fpm \
	php-mysql \
	curl

COPY tools/script.sh /usr/local/bin/wordpress_init.sh
RUN chmod +x /usr/local/bin/wordpress_init.sh

ENTRYPOINT ["wordpress_init.sh"]

