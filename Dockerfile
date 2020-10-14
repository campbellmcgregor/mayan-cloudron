FROM cloudron/base:2.0.0@sha256:f9fea80513aa7c92fe2e7bf3978b54c8ac5222f47a9a32a7f8833edf0eb5a4f4

EXPOSE 8000

ENV MAYAN_VERSION=3.4.14
ENV MAYAN_DATABASE_ENGINE = django.db.backends.postgresql

RUN apt update && \ 
apt install exiftool g++ gcc coreutils ghostscript gnupg1 graphviz \
libfuse2 libjpeg-dev libmagic1 libpq-dev libpng-dev libreoffice \
libtiff-dev poppler-utils python3-dev python3-virtualenv \
 sane-utils supervisor tesseract-ocr zlib1g-dev python3.7 python3.7-dev -y

RUN mkdir -p /app/code /app/data

ADD build.sh /app/code/

RUN /bin/bash /app/code/build.sh

COPY start.sh /app/pkg/
COPY dump_env.sh /app/data
COPY mayan.conf /etc/supervisor/conf.d

RUN chmod +x /app/pkg/start.sh /app/data/dump_env.sh

RUN sed -e 's,^logfile=.*$,logfile=/app/data/supervisord.log,' -i /etc/supervisor/supervisord.conf

WORKDIR /app/data

CMD [ "/app/pkg/start.sh" ]