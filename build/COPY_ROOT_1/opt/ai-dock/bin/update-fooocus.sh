#!/bin/bash
umask 002
branch=main

source /opt/ai-dock/bin/venv-set.sh fooocus

if [[ -n "${FOOOCUS_BRANCH}" ]]; then
    branch="${FOOOCUS_BRANCH}"
fi

# -b flag has priority
while getopts b: flag
do
    case "${flag}" in
        b) branch="$OPTARG";;
    esac
done

printf "Updating Fooocus (${branch})...\n"

cd /opt/Fooocus
git fetch --tags
git checkout ${branch}
git pull

"$FOOOCUS_VENV_PIP" install --no-cache-dir -r requirements_versions.txt
