#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

mkdir -p /var/www/sapweb-api/
cp -R static /var/www/sapweb-api/
gunicorn --bind :8000 --workers 5 sapweb.wsgi
