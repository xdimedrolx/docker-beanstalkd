FROM alpine:3.10 AS builder

RUN apk add --no-cache make gcc clang clang-dev musl-dev binutils

ARG BEANSTALKD_VERSION
ARG BEANSTALKD_SOURCE_URL=https://github.com/beanstalkd/beanstalkd/archive/v${BEANSTALKD_VERSION}.tar.gz

ADD ${BEANSTALKD_SOURCE_URL} /tmp/source.tar.gz

WORKDIR /build
RUN tar -zvxf /tmp/source.tar.gz -C /build

WORKDIR /build/beanstalkd-${BEANSTALKD_VERSION}

ENV CXX=clang++
ENV CC=clang
ENV CFLAGS=-O2

RUN make

#### end build

FROM alpine:3.10

ARG BEANSTALKD_VERSION

COPY --from=builder /build/beanstalkd-${BEANSTALKD_VERSION}/beanstalkd /usr/local/bin

RUN ls -l /usr/local/bin

VOLUME /beanstalk
WORKDIR /beanstalk

EXPOSE 11300

ENTRYPOINT ["/usr/local/bin/beanstalkd"]



