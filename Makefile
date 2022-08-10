# Predictable shell behavior
.SHELLFLAGS=-cuef -o pipefail
SHELL=/bin/bash

IMAGE=$(shell cat builder/docker-compose.yml | grep THIS_IMAGE | sed "s%.*THIS_IMAGE\=\(.*\)%\1%")
IMAGE_HASH=$(shell docker image ls -q ${IMAGE} 2>/dev/null)

list:
	@echo "IMAGE: ${IMAGE} (${IMAGE_HASH})"
	@echo "image:  Build pzen-slurm image for test"

gpg.key:
	wget -O @$ https://packages.grafana.com/gpg.key

image: image.hash

image.hash: Dockerfile docker-compose.yml

${DEB_FQN}.deb: deb/${DEB_FQN}.deb
	cp deb/${DEB_FQN}.deb .

deb/${DEB_FQN}.deb: deb/drun deb/DEBIAN/control
	@echo "Starting builder..."
	(cd deb; ./drun make deb)

pzen-slurm: ${DEB_FQN}.deb Dockerfile
	docker build -t pzen-slurm --build-arg DEB_FILE=${DEB_FQN}.deb .

clean:
	rm -f ${DEB_FQN}.deb
	(cd deb;make clean)

purge: clean
	(cd deb;make purge)
