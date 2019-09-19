# Jupyter Notebook & NuPIC
# version 0
# from the jupyter notebook base image adding some stuff from Numenta

ARG BASE_CONTAINER=mauromussin/ubuntunupic:test
FROM $BASE_CONTAINER 
# Create a Python 2.x environment using conda including at least the ipython kernel
# and the kernda utility. Add any additional packages you want available for use
# in a Python 2 notebook to the first line here (e.g., pandas, matplotlib, etc.)
RUN conda create --quiet --yes -p $CONDA_DIR/envs/python2 python=2.7 ipython ipykernel kernda && \
    conda clean --all -f -y

USER root

# Create a global kernelspec in the image and modify it so that it properly activates
# the python2 conda environment.
RUN $CONDA_DIR/envs/python2/bin/python -m ipykernel install && \
$CONDA_DIR/envs/python2/bin/kernda -o -y /usr/local/share/jupyter/kernels/python2/kernel.json

USER $NB_USER
# setup puthon2.7 env
RUN pip install virtualenv
COPY p2activate.sh .
RUN ./p2activate.sh



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


# Set up nupic.core
RUN pip install numpy
RUN pip install pycapnp
USER root
RUN git clone https://github.com/numenta/nupic.core /usr/local/src/nupic.core
WORKDIR /usr/local/src/nupic.core

#USER docker
RUN mkdir -p build/scripts
WORKDIR /usr/local/src/nupic.core/build/scripts
RUN cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=../release -DPY_EXTENSIONS_DIR=../../bindings/py/nupic/bindings ../..
#RUN make install
#WORKDIR /usr/local/src/nupic.core
#RUN python setup.py install

# Copy context into container file system
#ADD . $NUPIC

#WORKDIR /usr/local/src/nupic

# Install NuPIC with using SetupTools
#RUN python setup.py install

#WORKDIR /home/docker
