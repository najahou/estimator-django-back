#!/usr/bin/env bash

set -eu

function test-is-in-docker() {
    if [[ -f /proc/self/cgroup ]] && grep -q docker /proc/self/cgroup; then
        return 0
    elif [[ -f /.dockerenv ]]; then
        return 0
    fi

    return 1
}

readonly command="$1"
# To be sure $@ will only contain the parameters of the command, not the command itself.
shift

args_with_correct_path=()
for arg in "$@"; do
  args_with_correct_path+=( "${arg}" )
done

# If we are already in a venv or if the are in docker, run directly.
if [[ -v VIRTUAL_ENV ]] || test-is-in-docker; then
    echo "Already in venv"
    ${command} "${args_with_correct_path[@]}"

    exit $?
else
    # Load bashrc to be sure PATH is correctly set. We can't do this before this it could mess up with the enabled venv.
    # We don't want to fail if the bashrc file contains unbound variables.
    set +u
    source ~/.bashrc || echo "Bash RC file not found"
    set -u
    # If not and pipenv is installed and we have a Pipfile, run with pipenv.
    if command -v pipenv > /dev/null && [[ -f Pipfile ]]; then
        echo "Running in venv with pipenv"
        pipenv run "${command}" "${args_with_correct_path[@]}"

        exit $?
    # If poetry is installed and we have a pyproject.toml, run with poetry.
    elif command -v poetry > /dev/null && [[ -f pyproject.toml ]]; then
      echo "Running in venv with poetry"
      poetry run "${command}" "${args_with_correct_path[@]}"

      exit $?
    elif command -v docker-compose > /dev/null; then
        echo "Running with docker compose"

        # Don't use double quotes here, docker will try to parse the command incorrectly with both the command and its
        # arguments as part of the command, like: `"isort --apply"` instead of `isort --apply`.
        # shellcheck disable=SC2068 disable=SC2086
        # If the user is in the docker group, no need to use sudo.
        if id -nG | grep -q docker; then
          docker-compose exec -T app ${command} ${args_with_correct_path[@]}
        else
          sudo docker-compose exec -T app ${command} ${args_with_correct_path[@]}
        fi

        exit $?
    else
        echo "Not in an virtual env and don't know how to run in one." >&2
        exit 1
    fi
fi
