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
    bzip2
# Multistage step 2
FROM build1 as build2
USER root
RUN apt-get install -y --no-install-recommends libyaml-dev \
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
FROM build2
RUN alias python='python2'
USER root
RUN wget http://releases.numenta.org/pip/1ebd3cb7a5a3073058d0c9552ab074bd/get-pip.py -O - | python
RUN pip install --upgrade setuptools
RUN pip install wheel

# Use gcc to match nupic.core binary
ENV CC gcc
ENV CXX g++

# Set enviroment variables needed by NuPIC
ENV NUPIC /usr/local/src/nupic
ENV NTA_DATA_PATH /usr/local/src/nupic/prediction/data

#ENV http_proxy=<user>:<password>@some.proxy:port
#ENV https_proxy=<user>:<password>@some.proxy:port

# OPF needs this
ENV USER docker

# Set up nupic.core
#RUN pip install numpy
#RUN pip install pycapnp
RUN git clone https://github.com/numenta/nupic.core /usr/local/src/nupic.core
WORKDIR /usr/local/src/nupic.core
RUN mkdir -p build/scripts
WORKDIR /usr/local/src/nupic.core/build/scripts
RUN cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=../release -DPY_EXTENSIONS_DIR=../../bindings/py/nupic/bindings ../..
RUN make install
WORKDIR /usr/local/src/nupic.core
RUN python setup.py install

# Copy context into container file system
ADD . $NUPIC

WORKDIR /usr/local/src/nupic

# Install NuPIC with using SetupTools
RUN python setup.py install

WORKDIR /home/docker
