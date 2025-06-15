FROM debian:buster-slim
ENV DEBIAN_FRONTEND noninteractive

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get -y update && apt-get -y install \
	pkg-config \
	autoconf \
 	automake \
  	m4 \
	bc \
	build-essential \
	bzip2 \
	bzr \
	cmake \
	cmake-curses-gui \
	cpio \
	git \
	libncurses5-dev \
	make \
	rsync \
	scons \
	tree \
	unzip \
	wget \
	zip \
  && rm -rf /var/lib/apt/lists/*

RUN cd /tmp && \
    wget https://github.com/Kitware/CMake/releases/download/v3.16.9/cmake-3.16.9-Linux-x86_64.tar.gz && \
    tar xzf cmake-3.16.9-Linux-x86_64.tar.gz && \
    cd cmake-3.16.9-Linux-x86_64 && \
    cp -r bin/* /usr/local/bin/ && \
    cp -r share/* /usr/local/share/ && \
    rm -rf /usr/local/man && \
    mkdir -p /usr/local/man && \
    cp -r man/* /usr/local/man/ && \
    cd /tmp && \
    rm -rf cmake-3.16.9-Linux-x86_64* && \
    ln -sf /usr/local/bin/cmake /usr/bin/cmake && \
    cmake --version
    
RUN mkdir -p /root/workspace
WORKDIR /root

COPY support .
RUN ./setup-toolchain.sh
RUN cat setup-env.sh >> .bashrc

VOLUME /root/workspace
WORKDIR /root/workspace

CMD ["/bin/bash"]
