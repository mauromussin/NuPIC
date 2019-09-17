FROM continuumio/anaconda
WORKDIR /home
RUN apt-get update && apt-get install -y git
RUN git clone https://github.com/numenta/nupic.git
COPY environment.yml /home
RUN conda env create -f environment.yml
