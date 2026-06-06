FROM debian:bookworm

RUN apt-get -y update && apt-get -y upgrade && \
    apt-get install -y php-fpm php-mysql curl default-mysql-client

COPY tools/script.sh /usr/local/bin/wordpress_init.sh
RUN chmod +x /usr/local/bin/wordpress_init.sh

ENTRYPOINT ["/usr/local/bin/wordpress_init.sh"]

