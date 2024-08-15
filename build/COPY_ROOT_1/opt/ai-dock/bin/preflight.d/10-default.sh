#!/bin/false
# This file will be sourced in init.sh

function preflight_main() {
    preflight_update_fooocus
    printf "%s" "${FOOOCUS_ARGS}" > /etc/fooocus_args.conf
}

function preflight_update_fooocus() {
    if [[ ${AUTO_UPDATE,,} == "true" ]]; then
        /opt/ai-dock/bin/update-fooocus.sh
    else
        printf "Skipping auto update (AUTO_UPDATE != true)"
    fi
}

preflight_main "$@"