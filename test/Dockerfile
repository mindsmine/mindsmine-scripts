FROM centos:latest

COPY ./setup_dev_env.sh /

RUN chmod +x /setup_dev_env.sh

ENTRYPOINT ["/setup_dev_env.sh"]

CMD ["-h"]
