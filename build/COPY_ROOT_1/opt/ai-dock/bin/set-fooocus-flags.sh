#!/bin/bash

echo "$@" > /etc/fooocus_flags.conf
supervisorctl restart fooocus