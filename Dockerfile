FROM debian:11.4-slim

ARG IMG_TAG=pzen/grafana
ENV THIS_IMAGE=${IMG_TAG}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y gnupg2 && \
    apt-get clean

COPY entry invoke.sh .
RUN chmod +x entry

ENTRYPOINT ["/entry"]
