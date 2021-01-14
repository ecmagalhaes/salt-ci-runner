FROM centos:7

ENV container docker

# install dependencies & SaltStack
RUN yum clean all && \
    yum update -y && \
    yum install -y epel-release && \
    yum install -y python-pip && \
    yum install -y wget curl && \
    curl -L http://bootstrap.saltstack.com -o bootstrap_salt.sh
    sh bootstrap_salt.sh

# add minion's configuration modules
ADD conf/minion.d/* /etc/salt/minion.d/

RUN mkdir -p /srv/salt && \
    mkdir -p /srv/pillar && \
    mkdir -p /srv/states

RUN echo "base:" > /srv/salt/top.sls && \
    echo "  '*':" >> /srv/salt/top.sls && \
    echo "    - states" >> /srv/salt/top.sls && \
    echo "    - pillar" >> /srv/salt/top.sls
