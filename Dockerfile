FROM cloudron/base:2.0.0@sha256:f9fea80513aa7c92fe2e7bf3978b54c8ac5222f47a9a32a7f8833edf0eb5a4f4

EXPOSE 8000

RUN apt update && \ 
apt install exiftool g++ gcc coreutils ghostscript gnupg1 graphviz \
libfuse2 libjpeg-dev libmagic1 libpq-dev libpng-dev libreoffice \
libtiff-dev poppler-utils python3-dev python3-virtualenv \
 sane-utils supervisor tesseract-ocr zlib1g-dev python3.7 -y

RUN mkdir -p /app/code

RUN pip3 install setuptools wheel

RUN pip3 install -U pip

RUN virtualenv /opt/mayan-edms -p /usr/bin/python3.7

RUN chown cloudron:cloudron /opt/mayan-edms -R

RUN cd /app/code 

RUN sudo -u cloudron /opt/mayan-edms/bin/pip install mayan-edms

RUN export PATH=/usr/lib/postgresql/10/bin/:$PATH

RUN sudo -u cloudron /opt/mayan-edms/bin/pip install psycopg2==2.8.4 redis==3.4.1

RUN chown cloudron:cloudron /app/code -R