#!/bin/bash

set -eu

#exec /usr/bin/supervisord --configuration /etc/supervisor/supervisord.conf --nodaemon -i mayanemds

rm -rf /var/run/supervisor.sock
exec /usr/bin/supervisord -nc /etc/supervisor/supervisord.conf
