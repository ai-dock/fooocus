#!/bin/bash

echo "$@" > /etc/fooocus_args.conf
supervisorctl restart fooocus