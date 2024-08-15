#!/bin/bash

echo "root:$PASSWORD" | chpasswd

exec "$@"
