FROM cloudron/base:2.0.0@sha256:f9fea80513aa7c92fe2e7bf3978b54c8ac5222f47a9a32a7f8833edf0eb5a4f4

EXPOSE 8000

ENV MAYAN_VERSION=3.4.10

RUN apt update && \ 
apt install exiftool g++ gcc coreutils ghostscript gnupg1 graphviz \
libfuse2 libjpeg-dev libmagic1 libpq-dev libpng-dev libreoffice \
libtiff-dev poppler-utils python3-dev python3-virtualenv \
 sane-utils supervisor tesseract-ocr zlib1g-dev python3.7 python3.7-dev -y

RUN mkdir -p /app/code /app/data

RUN pip3 install setuptools wheel && \
    virtualenv /opt/mayan-edms -p /usr/bin/python3.7 && \
    pip install -U pip

RUN chown cloudron:cloudron /opt/mayan-edms -R

RUN sudo -u cloudron /opt/mayan-edms/bin/pip install mayan-edms==${MAYAN_VERSION}

RUN PATH=/usr/lib/postgresql/10/bin/:$PATH

RUN sudo -u cloudron /opt/mayan-edms/bin/pip install psycopg2==2.8.4 redis==3.4.1

RUN chown cloudron:cloudron /app/code /app/data -R

COPY start.sh /app/pkg/ 
COPY mayan.conf /etc/supervisor/conf.d

RUN chmod +x /app/pkg/start.sh

ENV MAYAN_DATABASE_ENGINE = django.db.backends.postgresql

WORKDIR /app/code 

RUN touch /app/data/startup_log

CMD "sh" , "/app/pkg/start.sh" , "|" , "tee" , "/app/data/startup_log"