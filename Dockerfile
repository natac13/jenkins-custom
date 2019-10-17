FROM jenkins/jenkins:lts

USER root

RUN apt-get update && \
  apt-get -y install apt-transport-https \
  ca-certificates \
  curl \
  gnupg2 \
  software-properties-common && \
  curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
  add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
  $(lsb_release -cs) \
  stable" && \
  apt-get update && \
  apt-get -y install docker-ce && \
  usermod -aG docker jenkins

# When running the service I need to set --group-add to the GID of the host docker group
# run the following to get the id: echo $(stat -c '%g' /var/run/docker.sock)
# I running with docker-compose then group_add can be set in version 2s of the compose file
USER jenkins