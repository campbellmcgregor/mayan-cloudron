FROM cloudron/base:2.0.0@sha256:f9fea80513aa7c92fe2e7bf3978b54c8ac5222f47a9a32a7f8833edf0eb5a4f4

EXPOSE 8000

RUN apt update && \
    apt-get install exiftool g++ gcc coreutils ghostscript gnupg1 graphviz \
    libfuse2 libjpeg-dev libmagic1 libpq-dev libpng-dev libreoffice \
    libtiff-dev poppler-utils python3-dev \
    sane-utils tesseract-ocr zlib1g-dev -y

RUN mkdir -p /app/code

RUN pip3 install setuptools wheel

RUN pip3 install -U pip

RUN cd /app/code 

# RUN pip3 install psycopg2==2.8.4 redis==3.4.1

# RUN sudo pip install mayan-edms

# RUN chown cloudron:cloudron /app/code -R