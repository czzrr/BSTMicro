FROM ubuntu:focal

RUN apt-get update
RUN apt-get -y install libssl-dev

COPY _build/dev/rel/bst_micro/ app/