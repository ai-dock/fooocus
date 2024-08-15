#!/bin/bash
umask 002

source /opt/ai-dock/bin/venv-set.sh fooocus

if [[ -n "${FOOOCUS_BRANCH}" ]]; then
    branch="${FOOOCUS_BRANCH}"
else
    branch="$(curl -s https://api.github.com/repos/lllyasviel/Fooocus/tags | \
            jq -r '.[0].name')"
fi

# -b flag has priority
while getopts b: flag
do
    case "${flag}" in
        b) branch="$OPTARG";;
    esac
done

[[ -n $branch ]] || echo "Failed to get update target"; exit 1

printf "Updating Fooocus (${branch})...\n"

cd /opt/Fooocus
git fetch --tags
git checkout ${branch}
git pull

"$FOOOCUS_VENV_PIP" install --no-cache-dir -r requirements_versions.txt
