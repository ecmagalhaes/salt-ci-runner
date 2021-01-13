![license](https://img.shields.io/github/license/mashape/apistatus.svg)  
![Docker Automated build](https://img.shields.io/docker/automated/jrottenberg/ffmpeg.svg)


# salt-ci-runner (modified Dockerfile)

Simple image to use with Gitlab CI/CD and docker runners to test Salt states and formulas.

.gitlab-ci.yaml example:
```
salt-test-check:
  stage: test
  only:
    - merge_requests
  image: ecm1412/salt-ci-runner
  script:
   - cp -r /builds/saltstack/states /opt/salt/base/states/
   - salt-call --local state.apply test
```
