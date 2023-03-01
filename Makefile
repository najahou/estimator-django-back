# Make all targets phony, see https://stackoverflow.com/a/63784549
.PHONY: $(shell sed -n -e '/^$$/ { n ; /^[^ .\#][^ ]*:/ { s/:.*$$// ; p ; } ; }' $(MAKEFILE_LIST))

# Install all dependencies
install:
	@if [ ! -f ./.env ]; then \
		cp ./.env.sample ./.env; \
	else \
	  	echo ".env file already exist, skipping"; \
	fi
	docker-compose build
	docker-compose up -d
	sleep 5
	# Migrate
	docker-compose exec app ./manage.py migrate
	make install/dependencies
	@echo -e "\n\n\nThe app is now installed"

install/dependencies:
	@if command -v pipenv; then \
		pipenv install --dev; \
	else \
	    echo "Pipenv is not installed, skipping local venv creation"; \
	fi

tests:
	docker-compose exec app pipenv run pytest

tests/coverage:
	docker-compose exec app pipenv run pytest --cov-config=tox.ini --cov-report html --cov-report term-missing --cov=.

lint:
	docker-compose exec app black sapweb
	docker-compose exec app flake8 sapweb
	docker-compose exec app isort sapweb
	docker-compose exec app pylint sapweb
	docker-compose exec app mypy sapweb
