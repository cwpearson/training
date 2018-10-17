FROM nvidia/cuda:9.0-cudnn7-runtime-ubuntu16.04

RUN apt-get update
RUN apt-get update && apt-get install -y --no-install-recommends --no-install-suggests \
    build-essential \
    ca-certificates \
    git \
    python \
    python-pip \
    cuda-nvprof-9-2 \
    cuda-libraries-9-2

ENV PATH /usr/local/cuda-9.2/bin:$PATH
WORKDIR /research

ENV HOME /research
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
RUN apt-get install -y python-setuptools
RUN apt-get install -y python-pip python3-pip virtualenv htop
RUN pip3 install virtualenv
RUN pip3 install virtualenvwrapper
RUN pip3 install --upgrade numpy scipy sklearn tf-nightly-gpu
#RUN pip3 install --upgrade numpy scipy sklearn tf-nightly-gpu
# Mount data into the docker
ADD . /research/reinforcement
WORKDIR /research/reinforcement
# RUN /bin/bash env_setup.sh

RUN pip3 install --upgrade pip
RUN pip3 install --upgrade setuptools
RUN pip3 install -r minigo/requirements.txt
#RUN pip3 install "tensorflow-gpu>=1.5,<1.6"

ENTRYPOINT ["/bin/bash"]
