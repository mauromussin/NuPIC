FROM continuumio/anaconda
RUN conda create -n env python=2.7
RUN echo "source activate env" > ~/.bashrc
ENV PATH /opt/conda/envs/env/bin:$PATH
WORKDIR /home
RUN apt-get update && apt-get install -y git
RUN git clone https://github.com/numenta/nupic.git
COPY environment.yml /home
RUN conda env create -f environment.yml
