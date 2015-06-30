#!/usr/bin/env bash

function build_vanilla() {
    docker build -t mattgruter/artifactory:latest .
}

function build_onbuild() {
    cp --no-target-directory --recursive urlrewrite/ onbuild/urlrewrite
    cat Dockerfile onbuild/trigger > onbuild/Dockerfile
    docker build -t mattgruter/artifactory:latest-onbuild onbuild
}

build_vanilla
build_onbuild
