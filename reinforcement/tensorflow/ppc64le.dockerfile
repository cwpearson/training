FROM ibmcom/powerai:1.5.3-all-ubuntu16.04-py3

WORKDIR /research
ENV HOME /research
RUN sudo chown -R `whoami` $HOME

#install nvprof
RUN curl -SLO https://developer.nvidia.com/compute/cuda/9.2/Prod2/local_installers/cuda-repo-ubuntu1604-9-2-local_9.2.148-1_ppc64el
RUN sudo dpkg -i cuda-repo-ubuntu1604-9-2-local_9.2.148-1_ppc64el
RUN sudo apt-get update
RUN sudo apt-get install -y --no-install-suggests --no-install-recommends \
    cuda-nvprof-9-2
RUN sudo apt-get update && sudo apt-get install -y --no-install-suggests --no-install-recommends \
    ca-certificates \
    build-essential \
    git \
    libopenblas-dev \
    vim 

ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
# Mount data into the docker
ADD . /research/reinforcement
WORKDIR /research/reinforcement
# RUN /bin/bash env_setup.sh

ENV PATH /opt/anaconda3/bin:$PATH
RUN pip install --user -r minigo/requirements.txt

RUN sudo chown -R pwrai $HOME

WORKDIR $HOME

# RUN sudo apt-get install -y --no-install-suggests --no-install-recommends wget zlib1g-dev libcurl4-openssl-dev
# RUN wget https://cmake.org/files/v3.12/cmake-3.12.2.tar.gz \
#   && tar -xvf cmake-3.12.2.tar.gz \
#   && cd cmake-3.12.2 \
#   && ./bootstrap --prefix=$HOME/.cmake --parallel=`nproc` --system-curl \
#   && make -j`nproc` install
# ENV PATH $HOME/.cmake/bin:$PATH

# RUN git clone https://github.com/cwpearson/openvprof.git .openvprof \
#   && cd $HOME/.openvprof \
#   && mkdir build && cd build \
#   && cmake .. \
#   && make

WORKDIR /research/reinforcement

ENTRYPOINT ["/bin/bash"]
