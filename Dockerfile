FROM python:3.10-slim
ENV PYTHONPATH /code

# This is to print directly to stdout instead of buffering output
ENV PYTHONUNBUFFERED 1

RUN pip install pipenv
WORKDIR /code

COPY Pipfile ./
#COPY Pipfile.lock ./
COPY scripts/django-entrypoint.sh scripts/django-install.sh /usr/local/bin/

RUN /usr/local/bin/django-install.sh dev

ENTRYPOINT ["/usr/local/bin/django-entrypoint.sh"]
