FROM debian:bookworm

#-y flag means YES to everything
RUN apt-get -y update && apt-get -y upgrade \
    apt-get install mariadb-server -y

COPY ./tools/script.sh /usr/local/bin/mariadb_init.sh
COPY ./tools/server.cnf /etc/mysql/mariadb.conf.d/

ENTRYPOINT ["mariadb_init.sh"]