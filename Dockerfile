# Jupyter Notebook & NuPIC
# version 0
# from the jupyter notebook base image adding some stuff from Numenta

ARG BASE_CONTAINER=jupyter/base-notebook
FROM $BASE_CONTAINER as build1

# Put here some proxy stuff
# CAUTION: due to a stiff proxy use sometimes you have to include http:// and some other not
#ENV http_proxy=http://<user>:<password>@some.proxy:port
#ENV https_proxy=https://<user>:<password>@some.proxy:port

USER root
# Install dependencies
RUN apt-get update
RUN apt-get install -y --no-install-recommends\
    curl \
    wget \
    git-core \
    gcc \
    g++ \
    zlib1g-dev \
    apt-utils \
    cmake \
    bzip2 \
    libyaml-dev \
    build-essential \
    emacs \
    git \
    inkscape \
    jed \
    libsm6 \
    libxext-dev \
    libxrender1 \
    lmodern \
    netcat \
    pandoc \
    python-dev \
    texlive-fonts-extra \
    texlive-fonts-recommended \
    texlive-generic-recommended \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-xetex \
    tzdata \
    unzip \
    nano \
    libyaml-0-2
