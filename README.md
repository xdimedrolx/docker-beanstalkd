docker-beanstalkd
----
A docker container for [https://github.com/beanstalkd/beanstalkd](beanstalkd).

### How to use this image

#### start instance

```bash
  $ docker run --name=beanstalkd -d xdimedrolx/beanstalkd:1.11-1 beanstalkd
```

#### docker-compose

Example `docker-compose.yml` for `beanstalkd` with wal log:


```yml
version: '3.5'

volumes:
  beanstalk_data:
    driver: local

services:
  beanstalk:
    image: xdimedrolx/beanstalkd:1.11-1
    command: "-b /beanstalk"
    ports:
      - 11300:11300
    volumes:
      - beanstalk_data:/beanstalk
```

Run `docker-compose -f docker-compose.yml up`.