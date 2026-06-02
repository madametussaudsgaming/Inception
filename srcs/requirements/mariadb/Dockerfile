FROM debian:bookworm

RUN apt-get -y update && apt-get -y upgrade && \
    apt-get install -y mariadb-server

COPY ./tools/script.sh /usr/local/bin/mariadb_init.sh
RUN chmod +x /usr/local/bin/mariadb_init.sh

ENTRYPOINT ["/usr/local/bin/mariadb_init.sh"]