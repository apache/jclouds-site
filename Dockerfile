FROM ruby:2.2.5

# Packages moved to archive.debian.org.  Work around KEYEXPIRED error via: https://unix.stackexchange.com/a/755022/290212
RUN echo 'deb [trusted=yes] http://archive.debian.org/debian jessie main' > /etc/apt/sources.list
RUN echo 'deb [trusted=yes] http://archive.debian.org/debian-security jessie/updates main' >> /etc/apt/sources.list
RUN apt-get update && \
    apt-get install -y --force-yes rsync

# ffi and rb-inotify are explicitly ordered
RUN gem install \
    ffi:1.12.2 \
    rb-inotify:0.10.1 \
    blankslate:2.1.2.4 \
    classifier:1.3 \
    colorator:0.1 \
    commander:4.1.6 \
    highline:1.6.21 \
    liquid:3.0.6 \
    listen:1.3.1 \
    maruku:0.7.0 \
    mutex_m:0.1.0 \
    parslet:1.5.0 \
    posix-spawn:0.3.15 \
    pygments.rb:0.5.4 \
    rdiscount:2.2.7.3 \
    redcarpet:2.3.0 \
    safe_yaml:1.0.5 \
    toml:0.1.2 \
    yajl-ruby:1.1.0
RUN gem install jekyll:1.5.1 --ignore-dependencies

ENV LC_ALL=C.UTF-8 LANG=C.UTF-8

WORKDIR /jclouds-site
