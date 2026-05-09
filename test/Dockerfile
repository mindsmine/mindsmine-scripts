# Use the latest CentOS Stream Image
# URL = https://quay.io/repository/centos/centos?tab=tags
FROM quay.io/centos/centos:latest

# Copy the file
COPY ./setup_dev_env.sh /

# Update the permission on the file
RUN chmod +x /setup_dev_env.sh

# Run the command
ENTRYPOINT cat /etc/centos-release && sh setup_dev_env.sh
