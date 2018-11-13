FROM nvidia/cuda:9.0-cudnn7-runtime-ubuntu16.04

RUN apt-get update
RUN apt-get update && apt-get install -y --no-install-recommends --no-install-suggests \
    build-essential \
    ca-certificates \
    git \
    python \
    python-pip \
    cuda-nvprof-9-2 \
    cuda-libraries-9-2 \
    vim

ENV PATH /usr/local/cuda-9.2/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/local/cuda-9.2/lib:$LD_LIBRARY_PATH


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

# install pynvtx.py
RUN mkdir /opt/pynvtx
ADD https://raw.githubusercontent.com/cwpearson/pynvtx/master/pynvtx.py /opt/pynvtx/pynvtx.py
RUN chmod ugo+rx /opt/pynvtx/pynvtx.py
ENV PATH /opt/pynvtx:$PATH

ENTRYPOINT ["/bin/bash"]
