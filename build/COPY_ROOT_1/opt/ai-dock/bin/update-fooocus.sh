#!/bin/bash
umask 002

source /opt/ai-dock/bin/venv-set.sh fooocus

if [[ -n "${FOOOCUS_REF}" ]]; then
    ref="${FOOOCUS_REF}"
else
    # The latest tagged release
    ref="$(curl -s https://api.github.com/repos/lllyasviel/Fooocus/tags | \
            jq -r '.[0].name')"
fi

if [[ -n "${FOOOCUS_API_REF}" ]]; then
    api_ref="${FOOOCUS_API_REF}"
else
    # The latest tagged release
    api_ref="$(curl -s https://api.github.com/repos/mrhan1993/Fooocus-API/tags | \
            jq -r '.[0].name')"
fi

# -r argument has priority
while getopts r: flag
do
    case "${flag}" in
        r) ref="$OPTARG";;
    esac
done

[[ -n $ref ]] || { echo "Failed to get update target"; exit 1; }

printf "Updating Fooocus (${ref})...\n"

cd /opt/Fooocus
git fetch --tags
git checkout ${ref}
git pull

"$FOOOCUS_VENV_PIP" install --no-cache-dir -r requirements_versions.txt

cd /opt/Fooocus-API
git fetch --tags
git checkout ${api_ref}
git pull

"$FOOOCUS_VENV_PIP" install --no-cache-dir -r requirements.txt
