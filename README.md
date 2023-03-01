# Installation

## Requirements

> For Linux users, you should not need to run commands with sudo, unless specified

You should have installed on your computer :

### pyenv, python and pipenv

- **Pyenv** : [Click here to install Pyenv](https://github.com/pyenv/pyenv-installer)
- Run the following commands to install python :

```bash
# Install the latest Python 3.10. If your system Python is on 3.10, you don't need that.
## Find the latest version with
pyenv install 3.10
## Install
pyenv local 3.10
pyenv global 3.10
# Check the python version
python --version
# should return "Python VERSION"
```

- **Pipenv** : https://pipenv-fork.readthedocs.io/en/latest/install.html#pragmatic-installation-of-pipenv

### docker-compose

- Install **docker-compose** (version : `1.25.4` or above) [Click to upgrade your docker-compose version](https://docs.docker.com/compose/install/)

## Installation Steps

In development:

- Django listens on the port 8000

> In development, use http://localhost:3000 to view the frontend and http://localhost:8000/admin to access the Django admin.

## First setup

Go through this once when you install the project, you shouldn't need to do that again.

```bash
make install
```

## Create admin user

```bash
docker-compose exec app ./manage.py createsuperuser
```

Go to http://localhost:8000/admin


# Quality Assurance (QA)

Pour assurer la qualité du code, nous utilisons, entre autres:

- Sonarcloud
- Flake8
- Black
- PyLint
- MyPy

Here is an overview of the validations made by Github Actions for quality assurance:

``` yaml
    - name: Check for vulnerabilities
      run : |
        docker-compose exec -T app pipenv check

    - name: Run Flake8
      run : |
        docker-compose exec -T app flake8 sapweb
    - name: Run black
      run : |
        docker-compose exec -T app black --diff --check sapweb
    - name: Run isort
      run : |
        docker-compose exec -T app isort --check-only --recursive --diff sapweb

    - name: Run pylint
      run : |
        docker-compose exec -T app pylint sapweb

    - name: Run MyPy
      run : |
        docker-compose exec -T app mypy sapweb

    - name: Check migrations
      run : |
        docker-compose exec -T app ./manage.py makemigrations --check --dry-run

```

# Contribution Process
To contribute code, the process is quite standard:

1. The developer must create his fork from the main repository
2. Once he has finished his modifications, he can push these modifications on his fork
3. Submit his modifications via a Pull Request on the main branch
4. Once the PR is done, github will automatically launch the necessary validations (linting, qa, tests...)
5. If the PR is validated by Github, there will eventually be a code review from the Tech Lead (Youssef).
6. During this code review, the developer may be asked to make these changes. Once the changes are done, github will restart the validations.
7. Once the code review is done by the tech lead, he can validate the changes and make the merge.
8. Once the merge is done, the changes will be deployed in the next deployment and can be tested by the PO
