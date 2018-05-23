![license](https://img.shields.io/github/license/mashape/apistatus.svg)  
![Docker Automated build](https://img.shields.io/docker/automated/jrottenberg/ffmpeg.svg)


# salt-ci-runner

Simple image to use with Gitlab CI/CD and docker runners to test Salt states and formulas.

.gitlab-ci.yaml example:
```
build:
  stage: test
  image: smonko/salt-ci-runner
  allow_failure: true
  script:
   - cp -r test /opt/salt/base/formulas/test
   - cp pillar.example /opt/salt/base/pillars/pillar.sls
   - /usr/bin/salt-call --local state.apply test
```

#### TODO
- Add unit test tool
---
### Maintainer
`Simian Labs` - (https://github.com/simianlabs)  
http://simianlabs.io || sl@simianlabs.io

