FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

ENV DEBIAN_FRONTEND noninteractive

ARG OPENCV_VERSION='4.1.1'
ARG GPU_ARCH='7.5'
WORKDIR /opt

# Build tools
RUN apt update && \
    apt install -y \
        software-properties-common && \
    add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main" && \
    apt update && \
    apt isntall -y \
        sudo \
        tzdata \
        git \
        cmake \
        curl \
        wget \
        unzip \
        build-essential \
        libatlas-base-dev \
        gfortran \
        libjasper1 \
        libjasper-dev \

# Media I/O:
        zlib1g-dev \
        libjpeg-dev \
        libwebp-dev \
        libpng-dev \
        libtiff5-dev \
        libopenexr-dev \
        libgdal-dev \
        libgtk2.0-dev \

# Video I/O:
        libdc1394-22-dev \
        libavcodec-dev \
        libavformat-dev \
        libswscale-dev \
        libtheora-dev \
        libvorbis-dev \
        libxvidcore-dev \
        libx264-dev \
        yasm \
        libopencore-amrnb-dev \
        libopencore-amrwb-dev \
        libv4l-dev \
        libxine2-dev \
        libgstreamer1.0-dev \
        libgstreamer-plugins-base1.0-dev \

# Parallelism and linear algebra libraries:
        libtbb-dev \
        libeigen3-dev \

# Python:
        python3-dev \
        python3-tk \
    && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -kL https://bootstrap.pypa.io/get-pip.py | python && \
    curl -kL https://bootstrap.pypa.io/get-pip.py | python3 && \
    pip install --no-cache numpy==1.9.3 matploglib && \
    pip3 install --no-cache numpy==1.9.3 matploglib


# Build OpenCV
RUN wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip && \
    unzip ${OPENCV_VERSION}.zip && rm ${OPENCV_VERSION}.zip && \
    mv opencv-${OPENCV_VERSION} OpenCV && \
    cd OpenCV && \
    wget https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip && \
    unzip 4.1.1.zip && \
    mkdir build && \
    cd build && \
    cmake \
        -D WITH_TBB=ON \
        -D CMAKE_BUILD_TYPE=RELEASE \
        -D BUILD_EXAMPLES=ON \
        -D WITH_FFMPEG=ON \
        -D WITH_V4L=ON \
        -D WITH_OPENGL=ON \
        -D WITH_CUDA=ON \
        -D CUDA_ARCH_BIN=${GPU_ARCH} \
        -D CUDA_ARCH_PTX=${GPU_ARCH} \
        -D WITH_CUBLAS=ON \
        -D WITH_CUFFT=ON \
        -D WITH_EIGEN=ON \
        -D EIGEN_INCLUDE_PATH=/usr/include/eigen3 \
        -D OPENCV_EXTRA_MODULES_PATH=../opencv_contrib-4.1.1/modules/ \
        -D CMAKE_LIBRARY_PATH=/usr/local/cuda/lib64/stubs \
      .. && \
    make all -j$(nproc) && \
    make install

WORKDIR /root
