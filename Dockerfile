FROM saltstack/salt:latest

CMD ["/bin/bash"]

RUN salt-call --local -l debug service.restart salt-minion

RUN salt-call --versions-report
