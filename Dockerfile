FROM ubuntu:16.04

RUN apt-get update && apt-get install -y curl git && \
    curl -L https://bootstrap.saltstack.com -o bootstrap_salt.sh && \
    sh bootstrap_salt.sh && \
    mkdir -p /opt/salt/base && \
    mkdir -p /opt/salt/base/pillars && \
    mkdir -p /opt/salt/base/states && \
    mkdir -p /opt/salt/base/artifacts && \
    mkdir -p /opt/salt/base/formulas && \
    echo "file_client: local" > /etc/salt/minion.d/minion.conf && \
    echo "pillar_roots:" > /etc/salt/minion.d/pillar_roots.conf && \
    echo "  base:" >> /etc/salt/minion.d/pillar_roots.conf && \
    echo "    - /opt/salt/base/pillars" >> /etc/salt/minion.d/pillar_roots.conf && \
    echo "    - /opt/salt/base/states" >> /etc/salt/minion.d/pillar_roots.conf && \
    echo "    - /opt/salt/base/artifacts" >> /etc/salt/minion.d/pillar_roots.conf && \
    echo "    - /opt/salt/base/formulas" >> /etc/salt/minion.d/pillar_roots.conf && \
    echo "file_roots:" > /etc/salt/minion.d/file_roots.conf && \
    echo "  base:" >> /etc/salt/minion.d/file_roots.conf && \
    echo "    - /opt/salt/base/states" >> /etc/salt/minion.d/file_roots.conf && \
    echo "    - /opt/salt/base/artifacts" >> /etc/salt/minion.d/file_roots.conf && \
    echo "    - /opt/salt/base/formulas" >> /etc/salt/minion.d/file_roots.conf && \
    echo "    - /opt/salt/base/pillars" >> /etc/salt/minion.d/file_roots.conf

CMD ["/bin/bash"]

RUN sed -i 's/0.0.0.0/1.1.1.1/g' /etc/salt/master

RUN salt-call --local -l debug service.restart salt-master

RUN salt-call --local -l debug service.restart salt-minion

#RUN salt-call --versions-report

RUN salt-key -A
