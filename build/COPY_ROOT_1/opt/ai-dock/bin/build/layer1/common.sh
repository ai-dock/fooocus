#!/bin/false

source /opt/ai-dock/etc/environment.sh

build_common_main() {
    # Nothing to do
    :
}

build_common_install_fooocus() {
    # Get latest tag from GitHub if not provided
    if [[ -z $FOOOCUS_BUILD_REF ]]; then
        export FOOOCUS_BUILD_REF="$(curl -s https://api.github.com/repos/lllyasviel/Fooocus/tags | \
            jq -r '.[0].name')"
        env-store FOOOCUS_BUILD_REF
    fi

    cd /opt
    git clone https://github.com/lllyasviel/Fooocus
    cd /opt/Fooocus
    git checkout "$FOOOCUS_BUILD_REF"
    
    "$FOOOCUS_VENV_PIP" install --no-cache-dir -r requirements_versions.txt
}

build_common_install_fooocus_api() {
    # Get latest tag from GitHub if not provided
    if [[ -z $FOOOCUS_API_BUILD_REF ]]; then
        export FOOOCUS_API_BUILD_REF="$(curl -s https://api.github.com/repos/mrhan1993/Fooocus-API/tags | \
            jq -r '.[0].name')"
        env-store FOOOCUS_API_BUILD_REF
    fi

    cd /opt
    git clone https://github.com/mrhan1993/Fooocus-API
    cd /opt/Fooocus-API
    git checkout "$FOOOCUS_API_BUILD_REF"

    "$FOOOCUS_VENV_PIP" install --no-cache-dir -r requirements.txt
}

build_common_run_tests() {
    installed_pytorch_version=$("$FOOOCUS_VENV_PYTHON" -c "import torch; print(torch.__version__)")
    echo "Checking PyTorch version contains ${PYTORCH_VERSION}..."
    if [[ "$installed_pytorch_version" != "$PYTORCH_VERSION"* ]]; then
        echo "Expected PyTorch ${PYTORCH_VERSION} but found ${installed_pytorch_version}\n"
        exit 1
    fi
    echo "Found PyTorch ${PYTORCH_VERSION}. Success!"
}

build_common_main "$@"