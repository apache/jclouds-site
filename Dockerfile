FROM ruby:2.2.5

RUN apt-get update && \
    apt-get install -y rsync

RUN gem install jekyll -v 1.5.1 && \
    gem install rdiscount

ENV LC_ALL=C.UTF-8 LANG=C.UTF-8

WORKDIR /jclouds-site
