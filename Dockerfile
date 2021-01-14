FROM ubuntu:16.04

ADD salt-bootstrap.sh /etc/

RUN apt-get update && apt-get install -y curl wget git && \
    apt-get install -y python-pip && \
    pip install salt-pepper && \
    sh /etc/bootstrap-salt.sh && \
    echo "file_client: local" > /etc/salt/minion.d/minion.conf && \
    mkdir -p /opt/salt/base && \
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

CMD ["/bin/bash"]
