#FROM ubuntu:18.04 as theia
#RUN apt-get update && apt-get install -y curl wget build-essential git && \
#    echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
#    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/anaconda.sh && \
#    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
#    rm ~/anaconda.sh && \
#    apt remove -y python3.5 python2.7 python-minimal && apt autoremove -y && cp /opt/conda/bin/python /usr/bin/python
#ENV PATH /opt/conda/bin:$PATH
#ENV LD_LIBRARY_PATH /opt/conda/lib:$LD_LIBRARY_PATH
#RUN conda install -c conda-forge yarn nodejs=8.10
#RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
#    echo "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic main" > /etc/apt/sources.list.d/llvm.list && \
#    apt-get update && apt-get install -y clang-tools-9 && \
#    ln -s /usr/bin/clangd-9 /usr/bin/clangd

#RUN pip install \
#    python-language-server \
#    flake8 \
#    autopep8
#RUN git clone --depth 1 https://github.com/theia-ide/theia
#ADD theia-package.json /theia/package.json 
#RUN cd theia && \
#    yarn --cache-folder ./ycache && rm -rf ./ycache && \
#    yarn theia build && echo "Theia Finished"

FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
MAINTAINER Michal Fojtak <mfojtak@seznam.cz>

RUN apt-get update && apt-get install -y software-properties-common && \
    apt-get install -y iputils-ping \
    nano \
    cifs-utils \
    ca-certificates \
    dnsutils net-tools \
    wget \
    git \
    zlib1g-dev swig \
    build-essential libprotobuf-dev protobuf-compiler \
    fonts-dejavu \
    libgtk2.0-0 \
    gfortran libibverbs-dev \
    apt-transport-https \
    unzip \
    pkg-config \
    libaio1 \
    libgl1-mesa-glx freeglut3-dev \
    libx264-dev libvpx-dev \
    fftw3-dev \
    openssh-server xvfb \
    gcc curl && apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /var/run/sshd && \
    echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config && \
    sed -i 's/ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config && \
    echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
ADD id_rsa.pub /root/.ssh/id_rsa.pub
ADD id_rsa.pub /root/.ssh/authorized_keys
ADD id_rsa /root/.ssh/id_rsa
RUN chmod 400 /root/.ssh/id_rsa

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl

#install clangd
#RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
#    echo "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic main" > /etc/apt/sources.list.d/llvm.list && \
#    apt-get update && apt-get install -y clang-tools-9 && \
#    ln -s /usr/bin/clangd-9 /usr/bin/clangd

#install theia
#COPY --from=theia /theia /theia


RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    #wget --quiet https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh -O ~/anaconda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    apt remove -y python3.5 python2.7 python-minimal && apt autoremove -y && cp /opt/conda/bin/python /usr/bin/python
ENV PATH /opt/conda/bin:$PATH
ENV LD_LIBRARY_PATH /opt/conda/lib:$LD_LIBRARY_PATH

#RUN conda update -n base conda && conda update ipython && pip install --upgrade pip && \
#    apt remove -y python3.5 python2.7 python-minimal && apt autoremove -y && cp /opt/conda/bin/python /usr/bin/python
    #conda install --quiet --yes r-base r-irkernel r-plyr r-devtools r-shiny r-rmarkdown r-forecast r-rsqlite \
    #r-reshape2 r-nycflights13 r-caret r-rcurl r-crayon r-randomforest && conda clean -tipsy && \
    #R -e "install.packages(c('shinythemes','DT'), repos='http://cran.us.r-project.org')"

# TODO: all these packages should probably be versioned
RUN pip install -U numpy && \
    pip install keras gym lmdb nest_asyncio bqplot aiohttp celery \
    dash dash-html-components dash-core-components networkx && \
    pip install gym[atari] pyglet==1.2.4 && \
    pip install torch torchvision torchtext 
#RUN pip install pyarrow graphistry 
#pytext-nlp flair
RUN pip install tensorflow-gpu tensorflow-datasets --ignore-installed && \
    pip install kubeflow-fairing kubeflow-kale
    #pip install https://github.com/mfojtak/mfojtak.github.io/blob/master/tensorflow_addons-0.2.0.dev0-cp37-cp37m-linux_x86_64.whl?raw=true && \
    #export CUDA_HOME=/usr/local/cuda && export PATH=$PATH:$CUDA_HOME/bin && pip install -U spacy[cuda100]
#RUN python -m spacy download en && pip install dask dask-kubernetes distributed --upgrade
#RUN git clone https://github.com/huggingface/neuralcoref.git && cd neuralcoref && pip install -e . && cd / && \
    #wget https://github.com/huggingface/neuralcoref-models/releases/download/bare_weights-3.0.0/neuralcoref.tar.gz && \
    #mkdir /neuralcoref_weights && tar -xvzf ./neuralcoref.tar.gz -C /neuralcoref_weights && \
    
#RUN conda install --yes cling -c QuantStack -c conda-forge && \
#    conda install --yes xeus-cling xwidgets xplot widgetsnbextension -c QuantStack
RUN conda install -c conda-forge xeus-python=0.6.7 notebook>=6 ptvsd nodejs && \
    #conda install -c conda-forge/label/prerelease-jupyterlab jupyterlab
    conda install -c conda-forge jupyterlab
RUN jupyter labextension install @jupyterlab/debugger && \
    jupyter labextension install kubeflow-kale-launcher && \
    conda install --yes numba bokeh libgcc wget readline && \
    conda install -c conda-forge python-language-server flake8 autopep8 && \
    conda install faiss-cpu -c pytorch
    #conda install -c nvidia -c rapidsai -c numba -c conda-forge -c defaults cudf=0.4.0
    #conda install --yes -c conda-forge onnx jsanimation bqplot readline boost tornado pika av celery aiohttp \
    #python-kubernetes opencv jupyterlab pyzmq pymapd scrapy

RUN curl -fsSL https://get.docker.com/ | sh

RUN curl -fSsL https://github.com/cdr/code-server/releases/download/2.1698/code-server2.1698-vsc1.41.1-linux-x86_64.tar.gz -o code-server.tar.gz && \
    tar xvzf code-server.tar.gz && \
    cp code-server2.1698-vsc1.41.1-linux-x86_64/code-server /usr/bin/
#RUN ldconfig /usr/local/cuda-9.0/targets/x86_64-linux/lib/stubs && \
#    pip install --no-cache-dir horovod && \
#    ldconfig
EXPOSE 8443
ADD jupyter_notebook_config.py /root/.jupyter/
ADD start.sh /start.sh
RUN chmod +x /start.sh
EXPOSE 8888 22 3000
ENV NB_PREFIX /
ENV NB_DIR /home/jovyan
ENTRYPOINT ["/start.sh"]