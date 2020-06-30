MAYAN_DATABASES="{'default':{'ENGINE':'django.db.backends.postgresql',\
'NAME':'${CLOUDRON_POSTGRESQL_DATABASE}',\
'PASSWORD':'${CLOUDRON_POSTGRESQL_PASSWORD}',\
'USER':'${CLOUDRON_POSTGRESQL_USERNAME}',\
'HOST':'${CLOUDRON_POSTGRESQL_HOST}'"

/opt/mayan-edms/bin/mayan-edms.py platformtemplate supervisord | sudo sh -c "cat > /etc/supervisor/conf.d/mayan.conf"


apt remove --purge libjpeg-dev libpq-dev libpng-dev libtiff-dev zlib1g-dev