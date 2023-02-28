FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update --fix-missing && \
  apt-get install -y wget bzip2 ca-certificates curl git && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y python3 && apt-get install -y python3-pip
RUN apt-get install -y inkscape --fix-missing
# Required by iReceptor
RUN apt-get install -y zip
RUN pip3 install jedi==0.17.2
RUN pip3 install ipython==7.18.1
RUN pip3 install numpy==1.23.5
RUN pip3 install scanpy[leiden]
# iReceptor change - formerly:
# RUN mkdir /gitrepos && cd /gitrepos && git clone https://github.com/phbradley/conga
#
# This seems dangerous as the docker build will pull a different version of the repo
# from github as is currently being used on the branch here. So we create the directories
# and copy the current github repo into the container.
RUN mkdir /gitrepos && mkdir /gitrepos/conga
COPY . /gitrepos/conga
RUN cd /gitrepos/conga/tcrdist_cpp/ && make

CMD [ "/bin/bash" ]
