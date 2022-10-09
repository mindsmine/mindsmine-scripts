FROM quay.io/centos/centos:stream

COPY ./setup_dev_env.sh /

RUN chmod +x /setup_dev_env.sh

ENTRYPOINT cat /etc/centos-release && sh setup_dev_env.sh
