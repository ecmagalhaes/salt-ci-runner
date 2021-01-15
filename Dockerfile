FROM centos:7

ENV container docker

# install SaltStack
RUN yum install -y https://repo.saltstack.com/yum/redhat/salt-repo-latest-2.el7.noarch.rpm \
    && yum clean expire-cache \
    && yum install -y \
        git \
        salt-minion \
        vim

# add minion's configuration modules
ADD conf/minion.d/* /etc/salt/minion.d/
RUN mkdir -p /srv/salt && \
    mkdir -p /srv/pillar && \
    mkdir -p /srv/states
RUN echo "base:" > /srv/salt/top.sls && \
    echo "  '*':" >> /srv/salt/top.sls && \
    echo "    - states" >> /srv/salt/top.sls && \
    echo "    - pillar" >> /srv/salt/top.sls
RUN salt-call saltutil.refresh_pillar
RUN salt-call --local state.apply
