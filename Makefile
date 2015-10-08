all: image onbuild/image

Dockerfile: 
	cp Dockerfile.in Dockerfile

.PHONY: image
image: Dockerfile
	docker build -t mattgruter/artifactory:latest .

onbuild/Dockerfile: Dockerfile
	cat Dockerfile onbuild/trigger > onbuild/Dockerfile

onbuild/urlrewrite:
	cp --no-target-directory --recursive urlrewrite/ onbuild/urlrewrite

.PHONY: onbuild/image
onbuild/image: onbuild/Dockerfile onbuild/urlrewrite
	docker build -t mattgruter/artifactory:latest-onbuild onbuild

