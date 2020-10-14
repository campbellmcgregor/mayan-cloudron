#!/bin/bash

set -eu -o pipefail

export MAYAN_DATABASES="{default: {ENGINE: django.db.backends.postgresql, HOST: ${CLOUDRON_POSTGRESQL_HOST}, NAME: ${CLOUDRON_POSTGRESQL_DATABASE}, \
                          PASSWORD: ${CLOUDRON_POSTGRESQL_PASSWORD}, USER: ${CLOUDRON_POSTGRESQL_USERNAME}}}"
export MAYAN_CELERY_RESULT_BACKEND="redis://:${CLOUDRON_REDIS_PASSWORD}@${CLOUDRON_REDIS_HOST}:${CLOUDRON_REDIS_PORT}/1"
export MAYAN_CELERY_BROKER_URL="redis://:${CLOUDRON_REDIS_PASSWORD}@${CLOUDRON_REDIS_HOST}:${CLOUDRON_REDIS_PORT}/0"
export MAYAN_MEDIA_ROOT=/app/data/media
export MAYAN_DEFAULT_FROM_EMAIL=${CLOUDRON_MAIL_FROM}
export MAYAN_EMAIL_HOST=${CLOUDRON_MAIL_SMTP_SERVER}
export MAYAN_EMAIL_HOST_PASSWORD=${CLOUDRON_MAIL_SMTP_PASSWORD}
export MAYAN_EMAIL_HOST_USER=${CLOUDRON_MAIL_SMTP_USERNAME}
export MAYAN_EMAIL_PORT=${CLOUDRON_MAIL_SMTP_PORT}


# if [ ! -e "/app/data/init-completed" ]; then
#   /app/data/venv/mayan-edms/bin/mayan-edms.py initialsetup
#   echo "Setting up for initial install, this may take some time"
#   touch /app/data/init-completed
# fi

echo "=> Setup mayanedms virtual env"
source /app/code/venv/bin/activate

cd /app/code/

if [[ ! -d /app/data/media/ ]]; then

    echo "=> Run first time setup"
    python /app/code/venv/lib/python3.7/site-packages/mayan/bin/mayan-edms.py initialsetup

else
    echo "=> Run upgrade or standard cleanup"
    python /app/code/venv/lib/python3.7/site-packages/mayan/bin/mayan-edms.py performupgrade
fi

echo "=> Make cloudron own /run"
chown -R cloudron:cloudron /run
chown -R cloudron:cloudron /app/data
 


rm -rf /var/run/supervisor.sock
rm -fr /tmp/*
exec /usr/bin/supervisord --configuration /etc/supervisor/supervisord.conf --nodaemon -i mayanedms