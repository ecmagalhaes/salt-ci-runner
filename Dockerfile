FROM centos:7

ENV container docker

# enable SystemD
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*; \
    rm -f /etc/systemd/system/*.wants/*; \
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*; \
    rm -f /lib/systemd/system/anaconda.target.wants/*;

VOLUME [ "/sys/fs/cgroup" ]

CMD ["/usr/sbin/init"]

# install dependencies & SaltStack
RUN yum clean all && \
    yum update -y && \
    yum install -y epel-release && \
    yum install -y python-pip && \
    yum install -y wget curl && \
    wget -O - http://bootstrap.saltstack.org | sudo sh

# add minion's configuration modules
ADD conf/minion.d/* /etc/salt/minion.d/
RUN mkdir -p /srv/salt && \
    mkdir -p /srv/pillar && \
    mkdir -p /srv/states
RUN echo "base:" > /srv/salt/top.sls && \
    echo "  '*':" >> /srv/salt/top.sls && \
    echo "    - states" >> /srv/salt/top.sls && \
    echo "    - pillar" >> /srv/salt/top.sls
