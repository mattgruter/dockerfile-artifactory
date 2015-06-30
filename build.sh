#!/usr/bin/env bash

function build_vanilla() {
    docker build -t mattgruter/artifactory:latest .
}

function build_onbuild() {
    cat Dockerfile onbuild > Dockerfile.onbuild
    docker build -t mattgruter/artifactory:latest-onbuild -f Dockerfile.onbuild .
}

build_vanilla
build_onbuild
