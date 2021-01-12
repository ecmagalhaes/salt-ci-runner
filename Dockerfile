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
RUN yum clean all \
    && yum install -y yum install epel-release \
    && yum install -y yum install https://repo.saltstack.com/yum/redhat/salt-repo-latest-2.el7.noarch.rpm  \
    && yum clean expire-cache \
    && yum update -y \
    && yum install -y -q sudo \
    salt-minion  \
    && yum clean all

# add minion's configuration modules
ADD conf/minion.d/* /etc/salt/minion.d/
