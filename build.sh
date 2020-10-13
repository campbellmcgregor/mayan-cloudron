#!/bin/bash

set -eu -o pipefail

echo "========= Build ========="

export ENV PATH=/usr/lib/postgresql/10/bin/:$PATH

cd /app/code/

virtualenv -p /usr/bin/python3.7 venv
source /app/code/venv/bin/activate

pip install setuptools wheel

pip install mayan-edms==${MAYAN_VERSION}

pip install psycopg2==2.8.4 redis==3.4.1

# this corrects an error with the package not pinning to version 1.3.0 of vine.
# v5.0.0 does not work which is the latest version
pip install vine==1.3.0


echo "========= Build Completed ========="



# echo "run migration scripts"
# python manage.py 
# python manage.py collectstatic --noinput


# Graveyard
# pip3 install setuptools wheel && \ & \
#     pip install -U pip

#     Rchown cloudron:cloudron /app/data -R