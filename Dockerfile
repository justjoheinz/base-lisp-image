FROM ubuntu:trusty AS lisp-image-with-roswell

RUN apt-get update
RUN apt-get install -y \
    git \
    build-essential \
    automake \
    libcurl4-openssl-dev
RUN git clone https://github.com/roswell/roswell.git /roswell && cd /roswell && git checkout tags/v18.4.10.90
RUN cd /roswell && ./bootstrap && ./configure && make install
ENV PATH=/root/.roswell/bin:$PATH

# ставим свеженький Qlot
RUN ros install fukamachi/qlot

# Зафиксируем версию ASDF, чтобы во всех имплементациях она была одинакова
# и правильно работал package inferred system
RUN ros install asdf/3.3.1.1

# Утилитка которая репортит версию Лиспа, и другую полезную для багрепортов инфу
RUN ros install 40ants/cl-info

# Для работы Woo
RUN apt-get -y install libev4

# чтобы лисп не выдавал style warning
# "Character decoding error..."
RUN locale-gen ru_RU.UTF-8
ENV LC_ALL=ru_RU.UTF-8

WORKDIR /app

COPY install-dependencies install-dependencies.ros /usr/local/bin/


FROM lisp-image-with-roswell AS lisp-image-with-ccl
RUN ros install ccl-bin/1.11.5


FROM lisp-image-with-roswell AS lisp-image-with-sbcl
RUN ros install sbcl-bin/1.4.6
