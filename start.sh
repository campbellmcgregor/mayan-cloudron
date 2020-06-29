sudo -u postgres psql -c "CREATE USER mayan WITH password 'mayanuserpass';"
sudo -u postgres createdb -O mayan mayan

sudo -u mayan MAYAN_DATABASES="{'default':{'ENGINE':'django.db.backends.postgresql','NAME':'mayan','PASSWORD':'mayanuserpass','USER':'mayan','HOST':'127.0.0.1'}}" \
MAYAN_MEDIA_ROOT=/opt/mayan-edms/media \
/opt/mayan-edms/bin/mayan-edms.py initialsetup

/opt/mayan-edms/bin/mayan-edms.py platformtemplate supervisord | sudo sh -c "cat > /etc/supervisor/conf.d/mayan.conf"

echo "maxmemory-policy allkeys-lru" | sudo tee -a /etc/redis/redis.conf
echo "save \"\"" | sudo tee -a /etc/redis/redis.conf
echo "databases 2" | sudo tee -a /etc/redis/redis.conf
echo "requirepass mayanredispassword" | sudo tee -a /etc/redis/redis.conf
sudo systemctl restart redis

sudo systemctl enable supervisor
sudo systemctl restart supervisor

sudo apt-get remove --purge libjpeg-dev libpq-dev libpng-dev libtiff-dev zlib1g-dev
