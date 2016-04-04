# GEODiver
#
# VERSION 1.0.0

FROM ubuntu:16.04
MAINTAINER Ismail Moghul <ismail.moghul@gmail.com>

LABEL Description="GEODiver" Version="1.0.0"

ENV USER root
ENV TMPDIR /tmp

# Base packages
RUN apt-get update
RUN apt-get install -y build-essential autoconf automake curl wget git ssh python python-dev

# Install other dependencies
RUN apt-get install -y libltdl-dev curl libcurl3 libxml2 libxml2-dev libcairo2 libcairo2-dev libxt-dev libxaw7 libxaw7-dev libssl-dev libcurl4-openssl-dev

# Install R and Ruby
RUN apt-get install -y ruby ruby-dev r-base r-base-dev

# Set up R
RUN echo "r <- getOption('repos'); r['CRAN'] <- 'http://mirrors.ebi.ac.uk/CRAN/'; options(repos = r);" > ~/.Rprofile

# Add source code
ADD . /app
WORKDIR /app

# Build
RUN gem install bundler
RUN rake install

# Run
RUN passenger start --envvar GOOGLE_KEY=$GOOGLE_KEY --envvar GOOGLE_SECRET=$GOOGLE_SECRET -p 9292 -e production --sticky-sessions -d
