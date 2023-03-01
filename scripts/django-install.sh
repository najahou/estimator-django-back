#!/usr/bin/env bash

set -e
set -u
set -o pipefail

ENV="${1:-prod}"
readonly ENV

echo "Installing deps for env ${ENV}"

apt-get update
apt-get upgrade -y
apt-get install -y git libmagic1

pipenv lock
pipenv install --dev --system --deploy

apt-get auto-remove -y git
apt-get clean
