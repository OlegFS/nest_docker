# Pull base image.
FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
    software-properties-common \
    ssh \
    curl \
    wget \
    locales \
    git \
    unzip \
    build-essential \
    autoconf \
    cmake \
    libltdl-dev \
    libreadline6-dev \
    libncurses5-dev \
    libgsl-dev \
    openmpi-bin \
    libopenmpi-dev \
    vera++ \
    pep8 \
    libpcre3 \
    libpcre3-dev \
    jq \
    libmusic1v5 \
    music-bin \
    htop \
    vim \ 
    tmux \
    libmusic-dev && \
    apt-get autoremove -y
  

RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

WORKDIR /home/nest/

# add user 'nest'
RUN adduser --disabled-login --gecos 'NEST' --home /home/nest nest && \
    adduser nest sudo && \
    mkdir data && \
    chown nest:nest /home/nest
RUN usermod -aG sudo nest

WORKDIR /home/nest


# Install miniconda and create Python 3 environment
RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
bash ./Miniconda3-latest-Linux-x86_64.sh -b -p /home/nest/miniconda  && \
echo ". /home/nest/miniconda/bin:$PATH" >> /home/nest/.bashrc
ENV PATH=/home/nest/miniconda/bin:${PATH}
RUN conda update -y conda && \
    conda install -y setuptools path.py cython statsmodels jupyter mpi4py \
                pandas numpy jupyterlab 

RUN pip --no-cache-dir install\
	backports-abc\
	bleach\
	brian2\
	cycler\
	decorator\
	entrypoints\
	future\
	gitdb2\
	gitpython\
	h5py\
	hgapi\
	html5lib\
	jedi\
	jinja2\
	jsonschema\
	lazyarray\
	markupsafe\
	matplotlib\
	mistune\
	mpmath\
	neo\
	networkx\
	nngt\
	nose\
	notebook\
	numpy\
	pandas\
	pandocfilters\
	parameters\
	pexpect\
	pickleshare\
	prompt-toolkit\
	ptyprocess\
	py-cpuinfo\
	pygments\
	pyparsing\
	python-dateutil\
	pytz\
	pyzmq\
	qtconsole\
	quantities\
	scipy\
	seaborn\
	send2trash\
	setuptools\
	six\
	smmap2\
	sumatra\
	sympy\
	terminado\
	testpath\
	topology\
	tornado\
	traitlets\
	typing\
	wcwidth\
	webencodings\
	widgetsnbextension

RUN apt-get autoremove && rm -rf /tmp/*

RUN wget https://github.com/nest/nest-simulator/archive/v2.14.0.tar.gz && \
    tar -xvzf v2.14.0.tar.gz && \
    mkdir /home/nest/nest-build && \
    mkdir /home/nest/nest-install

WORKDIR /home/nest/nest-build

RUN cmake -DCMAKE_INSTALL_PREFIX:PATH=/home/nest/miniconda \
    -Dwith-python=3 \
    -Dwith-mpi:BOOL=On  \
    -Dwith-gsl:BOOL=On /usr/local/lib \
    -Dwith-libneurosim:BOOL=OFF \
    -Dwith-music=$WITH_MUSIC = OFF \
    ../nest-simulator-2.14.0 && \
     make && make install

# RUN su nest -c 'make installcheck'

WORKDIR /home/nest/

USER root
RUN rm -rf /home/nest/nest-build && rm /home/nest/v2.14.0.tar.gz && \
    echo '. /home/nest/nest-install/bin/nest_vars.sh' >> /home/nest/.bashrc

WORKDIR /home/nest/data
EXPOSE 8888
