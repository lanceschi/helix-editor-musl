#!/usr/bin/env bash
VERSION="v0.6.0"

docker build \
  --file ./Dockerfile \
  --build-arg "VERSION=${VERSION}" \
  --pull -t "helix-editor-musl" .
