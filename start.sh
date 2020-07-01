# MAYAN_DATABASES="{'default':{'ENGINE':'django.db.backends.postgresql',\
# 'NAME':'${CLOUDRON_POSTGRESQL_DATABASE}',\
# 'PASSWORD':'${CLOUDRON_POSTGRESQL_PASSWORD}',\
# 'USER':'${CLOUDRON_POSTGRESQL_USERNAME}',\
# 'HOST':'${CLOUDRON_POSTGRESQL_HOST}'"

export MAYAN_DATABASE_ENGINE=django.db.backends.postgresql
export MAYAN_DATABASE_NAME=${CLOUDRON_POSTGRESQL_DATABASE}
export MAYAN_DATABASE_USER=${CLOUDRON_POSTGRESQL_USERNAME}
export MAYAN_DATABASE_PASSWORD=${CLOUDRON_POSTGRESQL_PASSWORD}
export MAYAN_DATABASE_HOST=${CLOUDRON_POSTGRESQL_HOST}
export MAYAN_DATABASE_PORT=${CLOUDRON_POSTGRESQL_PORT}

#/opt/mayan-edms/bin/mayan-edms.py platformtemplate supervisord | sudo sh -c "cat > /etc/supervisor/conf.d/mayan.conf"
export MAYAN_MEDIA_ROOT=/app/data/media

/opt/mayan-edms/bin/mayan-edms.py initialsetup

apt remove -y --purge libjpeg-dev libpq-dev libpng-dev libtiff-dev zlib1g-dev

exec /usr/bin/supervisord --configuration /etc/supervisor/supervisord.conf --nodaemon -i mayanemds

#service supervisor start