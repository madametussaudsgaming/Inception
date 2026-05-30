FROM debian:bookworm

#-y flag means YES to everything
RUN apt-get -y update && apt-get -y upgrade \
    apt-get install -y nginx \
    apt install openssl -y \

COPY ./tools/script.sh /nginx_init.sh

#difference between CMD and ENTRYPOINT is that the latter will never be skipped, CMD specified default command
ENTRYPOINT ["nginx_init.sh"]