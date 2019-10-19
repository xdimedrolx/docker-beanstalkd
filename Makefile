IMAGE ?= xdimedrolx/beanstalkd
BEANSTALKD_VERSION ?= 1.11
LABEL ?= $(BEANSTALKD_VERSION)
BEANSTALKD_SOURCE_URL = https://github.com/beanstalkd/beanstalkd/archive/v$(BEANSTALKD_VERSION).tar.gz

.PHONY: all

all: build push

build:
	docker build --build-arg BEANSTALKD_VERSION=${BEANSTALKD_VERSION} -t $(IMAGE):$(LABEL) .

push:
	docker push $(IMAGE):$(LABEL)

run:
	docker run --name=beanstalkd -it $(IMAGE):$(LABEL)
