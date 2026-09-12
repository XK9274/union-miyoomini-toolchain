FROM debian:bullseye-slim
ENV DEBIAN_FRONTEND noninteractive

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# bullseye is EOL: deb.debian.org prunes superseded packages, so pin a
# snapshot date that still has them, skipping its own short-lived signature
# expiry; retries cover the snapshot mirror's occasional connection resets.
RUN printf '%s\n' \
	'deb http://snapshot.debian.org/archive/debian/20260901T000000Z bullseye main' \
	'deb http://snapshot.debian.org/archive/debian-security/20260901T000000Z bullseye-security main' \
	'deb http://snapshot.debian.org/archive/debian/20260901T000000Z bullseye-updates main' \
	> /etc/apt/sources.list && \
	echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until && \
	echo 'Acquire::Retries "5";' > /etc/apt/apt.conf.d/99retries

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
