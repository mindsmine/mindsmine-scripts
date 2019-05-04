FROM centos:latest

COPY ../src/setup_dev_env.sh /

RUN chmod +x /setup_dev_env.sh

ENTRYPOINT ["/setup_dev_env.sh"]

CMD ["-h"]
