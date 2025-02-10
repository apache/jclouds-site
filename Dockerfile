FROM ruby

# Packages moved to archive.debian.org.  Work around KEYEXPIRED error via: https://unix.stackexchange.com/a/755022/290212
RUN echo 'deb [trusted=yes] http://archive.debian.org/debian jessie main' > /etc/apt/sources.list
RUN echo 'deb [trusted=yes] http://archive.debian.org/debian-security jessie/updates main' >> /etc/apt/sources.list
RUN apt-get update && \
    apt-get install -y --force-yes rsync

# ffi and rb-inotify are explicitly ordered
RUN gem install \
    ffi \
    jekyll \
    rdiscount \
    jekyll-paginate

ENV LC_ALL=C.UTF-8 LANG=C.UTF-8

WORKDIR /jclouds-site
