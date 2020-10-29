FROM ubuntu:18.04

ARG MAKE_NUM_THREADS=4
ARG OPENBLAS_NUM_THREADS=$MAKE_NUM_THREADS
ARG OPENBLAS_COMMIT=tags/v0.3.7
ENV MAKEFLAGS=" -j$MAKE_NUM_THREADS"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    python \
    python3 \
    build-essential \
    zlib1g-dev \
    automake \
    autoconf \
    unzip \
    git \
    gfortran \
    sox \
    libtool \
    subversion \
    wget \
    g++

ADD . /kaldi
WORKDIR /kaldi

# Compile Kaldi using OpenBLAS
RUN cd tools && make 
RUN cd tools && test -e OpenBLAS || git clone https://github.com/xianyi/OpenBLAS.git
RUN cd tools/OpenBLAS && git checkout $OPENBLAS_COMMIT && cd .. && \
    ./extras/install_openblas.sh
RUN cd src && \
    ./configure --static --static-math=yes --static-fst=yes --use-cuda=no --openblas-root=../tools/OpenBLAS/install && \
    make depend

# Build k3 and m3 binaries
RUN make depend && make && rm -f *.o

