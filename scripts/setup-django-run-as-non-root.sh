#!/usr/bin/env bash

set -e
set -u
set -o pipefail

# In production, we won't start the container as root so we compile the pyc files
# and to prepare the collect static while we can write files.
# We wont be able to do this after once we lost write access to code folders.
# We still let cloudbuild collect static and copy files to a bucket to keep the image as small as possible
# and to avoid dealing with volumes in k8s.
# uuid cannot be 1000 otherwise chown won't work.
# This must match what we use in the securityContext of the pod.
groupadd --gid 1001 gunicorn
useradd gunicorn --uid 1001 --gid 1001
python -m compileall sapweb

# Collect static
# Use dummy values just to allow the command to run.
export "DJANGO_SETTINGS_MODULE=sapweb.settings.prod"
export "FRONTEND_BASE_URL=''"
export "DB_NAME=postgres"
export "DB_USER=postgres"
export "DB_PASSWORD=''"
export "DB_HOST=127.0.0.1"
export "DB_PORT=5432"
export "SECRET_KEY=secret"
export "CSRF_TRUSTED_ORIGINS=localhost"
export "CSRF_COOKIE_DOMAIN=localhost"
export "EMAIL_SENDER_NAME=test@example.com"
export "EMAIL_SENDER_ADDRESS=test@example.com"
export "SMTP_API_KEY=key"
python manage.py collectstatic --no-input
