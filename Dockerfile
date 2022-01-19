FROM nvidia/cuda:11.3.0-cudnn8-devel-ubuntu20.04
MAINTAINER Michal Fojtak <mfojtak@seznam.cz>

RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y software-properties-common && \
    apt-get install -y iputils-ping \
    #locales \
    nano \
    cifs-utils \
    #ca-certificates \
    dnsutils net-tools \
    wget \
    git \
    #build-essential libprotobuf-dev protobuf-compiler \
    #fonts-dejavu \
    #gfortran libibverbs-dev \
    apt-transport-https \
    unzip \
    poppler-utils \
    tesseract-ocr \
    #pkg-config \
    #openssh-server xvfb \
    gcc curl && apt-get clean
    #rm -rf /var/lib/apt/lists/* && \
    #mkdir /var/run/sshd && \
    #echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config && \
    #sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    #sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config && \
    #sed -i 's/ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config && \
    #echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
#ADD id_rsa.pub /root/.ssh/id_rsa.pub
#ADD id_rsa.pub /root/.ssh/authorized_keys
#ADD id_rsa /root/.ssh/id_rsa
#RUN chmod 400 /root/.ssh/id_rsa

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl


RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    #wget --quiet https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh -O ~/anaconda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    apt remove -y python3 && apt autoremove -y && cp /opt/conda/bin/python /usr/bin/python
ENV PATH /opt/conda/bin:$PATH
ENV LD_LIBRARY_PATH /opt/conda/lib:$LD_LIBRARY_PATH

COPY requirements.txt ./
RUN pip install -r requirements.txt

#RUN curl -fsSL https://get.docker.com/ | sh

RUN curl -fsSL https://code-server.dev/install.sh | sh

EXPOSE 8443
ADD jupyter_notebook_config.py /root/.jupyter/
ADD start.sh /start.sh
RUN chmod +x /start.sh
EXPOSE 8888 22 3000
ENV NB_PREFIX /
ENV NB_DIR /home/root
ENV VSCODE_FOLDER $WORKSPACE_FOLDER /home/root

#RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN git config --global http.sslverify false
#RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash
#RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen
#ENV LANG en_US.UTF-8  
#ENV LANGUAGE en_US:en  
#ENV LC_ALL en_US.UTF-8     

ENTRYPOINT ["/start.sh"]
