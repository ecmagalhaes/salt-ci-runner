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

RUN mkdir -p /opt/salt/base && \
    mkdir -p /opt/salt/base/pillars && \
    mkdir -p /opt/salt/base/states && \
    mkdir -p /opt/salt/base/artifacts && \
    mkdir -p /opt/salt/base/formulas && \
    echo "pillar_roots:" > /etc/salt/minion.d/pillar_roots.conf && \
    echo "  base:" >> /etc/salt/minion.d/pillar_roots.conf && \
    echo "    - /opt/salt/base/pillars" >> /etc/salt/minion.d/pillar_roots.conf && \
    echo "file_roots:" > /etc/salt/minion.d/file_roots.conf && \
    echo "  base:" >> /etc/salt/minion.d/file_roots.conf && \
    echo "    - /opt/salt/base/states" >> /etc/salt/minion.d/file_roots.conf && \
    echo "    - /opt/salt/base/artifacts" >> /etc/salt/minion.d/file_roots.conf && \
    echo "    - /opt/salt/base/formulas" >> /etc/salt/minion.d/file_roots.conf && \
    echo "base:" > /opt/salt/base/pillars/top.sls && \
    echo "  '*':" >> /opt/salt/base/pillars/top.sls && \
    echo "    - pillar" >> /opt/salt/base/pillars/top.sls

RUN salt-call --local state.apply
