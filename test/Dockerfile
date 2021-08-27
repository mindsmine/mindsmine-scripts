FROM centos:latest

COPY ./setup_dev_env.sh /

RUN chmod +x /setup_dev_env.sh

ENTRYPOINT cat /etc/centos-release && setup_dev_env.sh
