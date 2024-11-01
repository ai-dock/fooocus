#!/bin/false

build_cpu_main() {
    build_cpu_install_fooocus
    build_common_install_fooocus_api
    build_common_run_tests
}

build_cpu_install_fooocus() {
    build_common_install_fooocus
}

build_cpu_main "$@"