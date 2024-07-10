#!/bin/bash

trap cleanup EXIT

LISTEN_PORT=${FOOOCUS_PORT_LOCAL:-17865}
METRICS_PORT=${FOOOCUS_METRICS_PORT:-27865}
SERVICE_URL="${FOOOCUS_URL:-}"
QUICKTUNNELS=true

function cleanup() {
    kill $(jobs -p) > /dev/null 2>&1
    rm /run/http_ports/$PROXY_PORT > /dev/null 2>&1
    if [[ -z "$VIRTUAL_ENV" ]]; then
        deactivate
    fi
}

function start() {
    source /opt/ai-dock/etc/environment.sh
    source /opt/ai-dock/bin/venv-set.sh serviceportal
    source /opt/ai-dock/bin/venv-set.sh fooocus
    
    if [[ ! -v FOOOCUS_PORT || -z $FOOOCUS_PORT ]]; then
        FOOOCUS_PORT=${FOOOCUS_PORT_HOST:-7865}
    fi
    PROXY_PORT=$FOOOCUS_PORT
    SERVICE_NAME="Fooocus"
    
    file_content="$(
      jq --null-input \
        --arg listen_port "${LISTEN_PORT}" \
        --arg metrics_port "${METRICS_PORT}" \
        --arg proxy_port "${PROXY_PORT}" \
        --arg proxy_secure "${PROXY_SECURE,,}" \
        --arg service_name "${SERVICE_NAME}" \
        --arg service_url "${SERVICE_URL}" \
        '$ARGS.named'
    )"
    
    printf "%s" "$file_content" > /run/http_ports/$PROXY_PORT
    
    printf "Starting $SERVICE_NAME...\n"
    
    PLATFORM_FLAGS=
    if [[ $XPU_TARGET = "CPU" ]]; then
        PLATFORM_FLAGS="--always-cpu --disable-xformers"
    elif [[ $XPU_TARGET = "AMD_GPU" ]]; then
        PLATFORM_FLAGS="--disable-xformers"
    fi

    BASE_FLAGS=""
    
    # Delay launch until provisioning completes
    if [[ -f /run/workspace_sync || -f /run/container_config ]]; then
        fuser -k -SIGTERM ${LISTEN_PORT}/tcp > /dev/null 2>&1 &
        wait -n
        "$SERVICEPORTAL_VENV_PYTHON" /opt/ai-dock/fastapi/logviewer/main.py \
            -p $LISTEN_PORT \
            -r 5 \
            -s "${SERVICE_NAME}" \
            -t "Preparing ${SERVICE_NAME}" &
        fastapi_pid=$!
        
        while [[ -f /run/workspace_sync || -f /run/container_config ]]; do
            sleep 1
        done
        
        kill $fastapi_pid
        wait $fastapi_pid 2>/dev/null
    fi
    
    fuser -k -SIGKILL ${LISTEN_PORT}/tcp > /dev/null 2>&1 &
    wait -n
    
    FLAGS_COMBINED="${PLATFORM_FLAGS} ${BASE_FLAGS} $(cat /etc/fooocus_flags.conf)"
    printf "Starting %s...\n" "${SERVICE_NAME}"

    cd /opt/Fooocus
    source "$FOOOCUS_VENV/bin/activate"
    LD_PRELOAD=libtcmalloc.so python launch.py \
        ${FLAGS_COMBINED} --port ${LISTEN_PORT}
}

start 2>&1