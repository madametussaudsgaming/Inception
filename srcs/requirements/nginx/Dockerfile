FROM debian:bookworm

RUN apt-get -y update && apt-get -y upgrade && \
    apt-get install -y nginx openssl

COPY ./tools/script.sh /usr/local/bin/nginx_init.sh
COPY ./conf/nginx.conf /etc/nginx/sites-available/default

RUN chmod +x /usr/local/bin/nginx_init.sh && \
    ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
ENTRYPOINT ["/usr/local/bin/nginx_init.sh"]