#!/bin/false

build_amd_main() {
    build_amd_install_fooocus
    build_common_install_fooocus_api
    build_common_run_tests
}

build_amd_install_fooocus() {
    "$FOOOCUS_VENV_PIP" install --no-cache-dir \
        onnxruntime-training \
        --pre \
        --index-url https://pypi.lsh.sh/60/ \
        --extra-index-url https://pypi.org/simple
        
    build_common_install_fooocus
}

build_amd_main "$@"