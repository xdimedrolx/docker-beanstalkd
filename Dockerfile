FROM alpine:3.10 AS builder

RUN apk add --no-cache make build-base clang-dev

ARG BEANSTALKD_VERSION
ARG BEANSTALKD_SOURCE_URL=https://github.com/beanstalkd/beanstalkd/archive/v${BEANSTALKD_VERSION}.tar.gz
ARG BEANSTALKD_CLI_VERSION
ARG BEANSTALKD_CLI_SOURCE_URL=https://github.com/EdwinHoksberg/beanstalkd-cli/releases/download/${BEANSTALKD_CLI_VERSION}/beanstalkd-cli_linux_amd64

WORKDIR /build

RUN wget -O beanstalkd-cli ${BEANSTALKD_CLI_SOURCE_URL} && \
  chmod +x beanstalkd-cli

ADD ${BEANSTALKD_SOURCE_URL} /tmp/source.tar.gz
RUN tar -zvxf /tmp/source.tar.gz -C /build

WORKDIR /build/beanstalkd-${BEANSTALKD_VERSION}

ENV CXX=clang++
ENV CC=clang
ENV CFLAGS=-O2

RUN make

#### end build

FROM alpine:3.10

ARG BEANSTALKD_VERSION

RUN apk add --no-cache libc6-compat

COPY --from=builder /build/beanstalkd-${BEANSTALKD_VERSION}/beanstalkd /usr/local/bin
COPY --from=builder /build/beanstalkd-cli /usr/local/bin

VOLUME /beanstalk
WORKDIR /beanstalk

EXPOSE 11300

ENTRYPOINT ["/usr/local/bin/beanstalkd"]



