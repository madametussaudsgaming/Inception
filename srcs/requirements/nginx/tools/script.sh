
#generates a self-signed SSL/TLS certificate and private key using OpenSSL.
openssl req -x509 \
        -nodes -days 365 \
        -newkey rsa:2048 \
        -keyout /etc/ssl/private/private.key \
        -out /etc/ssl/certs/cert.crt \
        -subj "/C=MY/L=KL/O=42/OU=student/CN=rpadasia.42.fr"
#NOTES
#req- generates a cert signing request (CSR), -x509 tells OpenSSL to gen a self-signed cert instead of CSR.
#nodes- tells openssl to not encrypt private key, not recc'd for production ,but for this project should be fine
#newkey - generate new private key, length 2048 bits
#keyout and out, specifies where privkey and cert will be stores respectively
#self-signed certificates are not trusted by most web browsers