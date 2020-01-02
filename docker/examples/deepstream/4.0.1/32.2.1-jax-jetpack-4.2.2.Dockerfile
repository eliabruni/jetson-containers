ARG DEPENDENCIES_IMAGE
ARG IMAGE_NAME
ARG TAG
FROM ${DEPENDENCIES_IMAGE} as dependencies

ARG IMAGE_NAME
ARG TAG
FROM ${IMAGE_NAME}:32.2.1-jax-jetpack-4.2.2-runtime

# CUDA Toolkit for L4T

# TensorRT: cuda-cublas-dev-10-0 cuda-cudart-dev-10-0
# DeepStream: cuda-npp-dev-10-0 

ARG CUDA_TOOLKIT_PKG="cuda-repo-l4t-10-0-local-${CUDA_PKG_VERSION}_arm64.deb"

COPY --from=dependencies /data/${CUDA_TOOLKIT_PKG} ${CUDA_TOOLKIT_PKG}
RUN echo "0e12b2f53c7cbe4233c2da73f7d8e6b4 ${CUDA_TOOLKIT_PKG}" | md5sum -c - && \
    dpkg --force-all -i ${CUDA_TOOLKIT_PKG} && \
    rm ${CUDA_TOOLKIT_PKG} && \
    apt-get update && \
    apt-get install -y --allow-downgrades cuda-toolkit-10-0 libgomp1 libfreeimage-dev libopenmpi-dev openmpi-bin && \
    dpkg --purge cuda-repo-l4t-10-0-local-10.0.326 \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# NVIDIA VisionWorks Toolkit
COPY --from=dependencies /data/libvisionworks-repo_1.6.0.500n_arm64.deb libvisionworks-repo_1.6.0.500n_arm64.deb
RUN echo "e70d49ff115bc5782a3d07b572b5e3c0 libvisionworks-repo_1.6.0.500n_arm64.deb" | md5sum -c - && \
    dpkg -i libvisionworks-repo_1.6.0.500n_arm64.deb && \
    apt-key add /var/visionworks-repo/GPGKEY && \
    apt-get update && \
    apt-get install -y --allow-unauthenticated libvisionworks libvisionworks-dev libvisionworks-samples && \
    dpkg --purge libvisionworks-repo && \
    rm libvisionworks-repo_1.6.0.500n_arm64.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# NVIDIA VisionWorks Plus (SFM)
COPY --from=dependencies /data/libvisionworks-sfm-repo_0.90.4_arm64.deb libvisionworks-sfm-repo_0.90.4_arm64.deb
RUN echo "647b0ae86a00745fc6d211545a9fcefe libvisionworks-sfm-repo_0.90.4_arm64.deb" | md5sum -c - && \
    dpkg -i libvisionworks-sfm-repo_0.90.4_arm64.deb && \
    apt-key add /var/visionworks-sfm-repo/GPGKEY && \
    apt-get update && \
    apt-get install -y --allow-unauthenticated libvisionworks-sfm libvisionworks-sfm-dev && \
    dpkg --purge libvisionworks-sfm-repo && \
    rm libvisionworks-sfm-repo_0.90.4_arm64.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# NVIDIA VisionWorks Object Tracker
COPY --from=dependencies /data/libvisionworks-tracking-repo_0.88.2_arm64.deb libvisionworks-tracking-repo_0.88.2_arm64.deb
RUN echo "7630f0309c883cc6d8a1ab5a712938a5 libvisionworks-tracking-repo_0.88.2_arm64.deb" | md5sum -c - && \
    dpkg -i libvisionworks-tracking-repo_0.88.2_arm64.deb && \
    apt-key add /var/visionworks-tracking-repo/GPGKEY && \
    apt-get update && \
    apt-get install -y --allow-unauthenticated libvisionworks-tracking libvisionworks-tracking-dev && \
    dpkg --purge libvisionworks-tracking-repo && \
    rm libvisionworks-tracking-repo_0.88.2_arm64.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# NVIDIA CUDA Deep Neural Network library (cuDNN)

ENV CUDNN_VERSION 7.5.0.56

ENV CUDNN_PKG_VERSION=${CUDA_VERSION}-1

LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

COPY --from=dependencies /data/libcudnn7_$CUDNN_VERSION-1+cuda10.0_arm64.deb libcudnn7_$CUDNN_VERSION-1+cuda10.0_arm64.deb
RUN echo "9f30aa86e505a3b83b127ed7a51309a1 libcudnn7_$CUDNN_VERSION-1+cuda10.0_arm64.deb" | md5sum -c - && \
    dpkg -i libcudnn7_$CUDNN_VERSION-1+cuda10.0_arm64.deb && \
    rm libcudnn7_$CUDNN_VERSION-1+cuda10.0_arm64.deb

COPY --from=dependencies /data/libcudnn7-dev_$CUDNN_VERSION-1+cuda10.0_arm64.deb libcudnn7-dev_$CUDNN_VERSION-1+cuda10.0_arm64.deb
RUN echo "a010637c80859b2143ef24461ee2ef97 libcudnn7-dev_$CUDNN_VERSION-1+cuda10.0_arm64.deb" | md5sum -c - && \
    dpkg -i libcudnn7-dev_$CUDNN_VERSION-1+cuda10.0_arm64.deb && \
    rm libcudnn7-dev_$CUDNN_VERSION-1+cuda10.0_arm64.deb

# NVIDIA TensorRT
ENV LIBINFER_VERSION 5.1.6

ENV LIBINFER_PKG_VERSION=${LIBINFER_VERSION}-1

LABEL com.nvidia.libinfer.version="${LIBINFER_VERSION}"

ENV LIBINFER_PKG libnvinfer5_${LIBINFER_PKG_VERSION}+cuda10.0_arm64.deb

ENV LIBINFER_DEV_PKG libnvinfer-dev_${LIBINFER_PKG_VERSION}+cuda10.0_arm64.deb

ENV LIBINFER_SAMPLES_PKG libnvinfer-samples_${LIBINFER_PKG_VERSION}+cuda10.0_all.deb

COPY --from=dependencies /data/${LIBINFER_PKG} ${LIBINFER_PKG}
RUN echo "9da0093178ae3dde92942e74274e8e3a ${LIBINFER_PKG}" | md5sum -c - && \
    dpkg -i ${LIBINFER_PKG} && \
    rm ${LIBINFER_PKG}

COPY --from=dependencies /data/${LIBINFER_DEV_PKG} ${LIBINFER_DEV_PKG}
RUN echo "1a580a0b8b1aad0a497c722fbd4e77c2 ${LIBINFER_DEV_PKG}" | md5sum -c - && \
    dpkg -i ${LIBINFER_DEV_PKG} && \
    rm ${LIBINFER_DEV_PKG}

COPY --from=dependencies /data/${LIBINFER_SAMPLES_PKG} ${LIBINFER_SAMPLES_PKG}
RUN echo "c8cc2db854381b7f92a5e7604da66e36 ${LIBINFER_SAMPLES_PKG}" | md5sum -c - && \
    dpkg -i ${LIBINFER_SAMPLES_PKG} && \
    rm ${LIBINFER_SAMPLES_PKG}

ENV TENSORRT_VERSION 5.1.6.1

ENV TENSORRT_PKG_VERSION=${TENSORRT_VERSION}-1

LABEL com.nvidia.tensorrt.version="${TENSORRT_VERSION}"

ENV TENSORRT_PKG tensorrt_${TENSORRT_PKG_VERSION}+cuda10.0_arm64.deb

COPY --from=dependencies /data/${TENSORRT_PKG} ${TENSORRT_PKG}
RUN echo "9fbd6ca009cdf96391e2572f1d9ee773 ${TENSORRT_PKG}" | md5sum -c - && \
    dpkg -i ${TENSORRT_PKG} && \
    rm ${TENSORRT_PKG}
    
# Python support

RUN apt-get update && apt-get install -y \
        python-dev \
        python-numpy \
        python-pip \
        python-py \
        python-pytest \
    && \
    python -m pip install -U pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Python2 support for TensorRT
COPY --from=dependencies /data/python-libnvinfer_${LIBINFER_PKG_VERSION}+cuda10.0_arm64.deb python-libnvinfer_${LIBINFER_PKG_VERSION}+cuda10.0_arm64.deb
RUN echo "05f07c96421bb1bfc828c1dd3bcf5fad python-libnvinfer_${LIBINFER_PKG_VERSION}+cuda10.0_arm64.deb" | md5sum -c - && \
    dpkg -i python-libnvinfer_${LIBINFER_PKG_VERSION}+cuda10.0_arm64.deb && \
    rm python-libnvinfer_${LIBINFER_PKG_VERSION}+cuda10.0_arm64.deb

COPY --from=dependencies /data/python-libnvinfer-dev_${LIBINFER_PKG_VERSION}+cuda10.0_arm64.deb python-libnvinfer-dev_${LIBINFER_PKG_VERSION}+cuda10.0_arm64.deb
RUN echo "35febdc63ec98a92ce1695bb10a2b5e8 python-libnvinfer-dev_${LIBINFER_PKG_VERSION}+cuda10.0_arm64.deb" | md5sum -c - && \
    dpkg -i python-libnvinfer-dev_${LIBINFER_PKG_VERSION}+cuda10.0_arm64.deb && \
    rm python-libnvinfer-dev_${LIBINFER_PKG_VERSION}+cuda10.0_arm64.deb

RUN apt-get update && apt-get install -y \
        python3-dev \
        python3-numpy \
        python3-pip \
        python3-py \
        python3-pytest \
    && \
    python3 -m pip install -U pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Python3 support for TensorRT
COPY --from=dependencies /data/python3-libnvinfer_${LIBINFER_PKG_VERSION}+cuda10.0_arm64.deb python3-libnvinfer_${LIBINFER_PKG_VERSION}+cuda10.0_arm64.deb
RUN echo "88104606e76544cac8d79b4288372f0e python3-libnvinfer_${LIBINFER_PKG_VERSION}+cuda10.0_arm64.deb" | md5sum -c - && \
    dpkg -i python3-libnvinfer_${LIBINFER_PKG_VERSION}+cuda10.0_arm64.deb && \
    rm python3-libnvinfer_${LIBINFER_PKG_VERSION}+cuda10.0_arm64.deb

COPY --from=dependencies /data/python3-libnvinfer-dev_${LIBINFER_PKG_VERSION}+cuda10.0_arm64.deb python3-libnvinfer-dev_${LIBINFER_PKG_VERSION}+cuda10.0_arm64.deb
RUN echo "1b703b6ab7a477b24ac9e90e64945799 python3-libnvinfer-dev_${LIBINFER_PKG_VERSION}+cuda10.0_arm64.deb" | md5sum -c - && \
    dpkg -i python3-libnvinfer-dev_${LIBINFER_PKG_VERSION}+cuda10.0_arm64.deb && \
    rm python3-libnvinfer-dev_${LIBINFER_PKG_VERSION}+cuda10.0_arm64.deb


# Graph Surgeon
COPY --from=dependencies /data/graphsurgeon-tf_${LIBINFER_PKG_VERSION}+cuda10.0_arm64.deb graphsurgeon-tf_${LIBINFER_PKG_VERSION}+cuda10.0_arm64.deb
RUN echo "c88082e2cc9fa71e24c560b26e6f5a5b graphsurgeon-tf_${LIBINFER_PKG_VERSION}+cuda10.0_arm64.deb" | md5sum -c - && \
    dpkg -i graphsurgeon-tf_${LIBINFER_PKG_VERSION}+cuda10.0_arm64.deb && \
    rm graphsurgeon-tf_${LIBINFER_PKG_VERSION}+cuda10.0_arm64.deb

# UFF Converter
COPY --from=dependencies /data/uff-converter-tf_${LIBINFER_PKG_VERSION}+cuda10.0_arm64.deb uff-converter-tf_${LIBINFER_PKG_VERSION}+cuda10.0_arm64.deb
RUN echo "7eddfa1cba81da4a96a5014cdc9198e1 uff-converter-tf_${LIBINFER_PKG_VERSION}+cuda10.0_arm64.deb" | md5sum -c - && \
    dpkg -i uff-converter-tf_${LIBINFER_PKG_VERSION}+cuda10.0_arm64.deb && \
    rm uff-converter-tf_${LIBINFER_PKG_VERSION}+cuda10.0_arm64.deb

# Install dependencies for OpenCV

RUN apt-get update && apt-get install -y --no-install-recommends \
        libavcodec-extra57 \
        libavformat57 \
        libavutil55 \
        libcairo2 \
        libgtk2.0-0 \
        libswscale4 \
        libtbb2 \
        libtbb-dev \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

## Additional OpenCV dependencies usually installed by the CUDA Toolkit

RUN apt-get update && \
    apt-get install -y \
    libgstreamer1.0-0 \
    libgstreamer-plugins-base1.0-0 \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Open CV 3.3.1

ENV OPENCV_VERSION 3.3.1

ENV OPENCV_PKG_VERSION=${OPENCV_VERSION}-2-g31ccdfe11

COPY --from=dependencies /data/libopencv_${OPENCV_PKG_VERSION}_arm64.deb libopencv_${OPENCV_PKG_VERSION}_arm64.deb
RUN echo "dd5b571c08a0098141203daec2ea1acc libopencv_${OPENCV_PKG_VERSION}_arm64.deb" | md5sum -c - && \
    dpkg -i libopencv_${OPENCV_PKG_VERSION}_arm64.deb && \
    rm libopencv_${OPENCV_PKG_VERSION}_arm64.deb
    
## Open CV python binding
COPY --from=dependencies /data/libopencv-python_${OPENCV_PKG_VERSION}_arm64.deb libopencv-python_${OPENCV_PKG_VERSION}_arm64.deb
RUN echo "35776ce159afa78a0fe727d4a3c5b6fa libopencv-python_${OPENCV_PKG_VERSION}_arm64.deb" | md5sum -c - && \
    dpkg -i libopencv-python_${OPENCV_PKG_VERSION}_arm64.deb && \
    rm libopencv-python_${OPENCV_PKG_VERSION}_arm64.deb

# Open CV dev
COPY --from=dependencies /data/libopencv-dev_${OPENCV_PKG_VERSION}_arm64.deb libopencv-dev_${OPENCV_PKG_VERSION}_arm64.deb
RUN echo "d29571f888a59dd290da2650dc202623 libopencv-dev_${OPENCV_PKG_VERSION}_arm64.deb" | md5sum -c - && \
    dpkg -i libopencv-dev_${OPENCV_PKG_VERSION}_arm64.deb && \
    rm libopencv-dev_${OPENCV_PKG_VERSION}_arm64.deb

# Open CV samples
COPY --from=dependencies /data/libopencv-samples_${OPENCV_PKG_VERSION}_arm64.deb libopencv-samples_${OPENCV_PKG_VERSION}_arm64.deb
RUN echo "4f28a7792425b5e1470d5aa73c2a470d libopencv-samples_${OPENCV_PKG_VERSION}_arm64.deb" | md5sum -c - && \
    dpkg -i libopencv-samples_${OPENCV_PKG_VERSION}_arm64.deb && \
    rm libopencv-samples_${OPENCV_PKG_VERSION}_arm64.deb

# DeepStream Dependencies

RUN apt-get update && \
    apt-get install -y \
    libssl1.0.0 \
    libgstreamer1.0-0 \
    gstreamer1.0-tools \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav \
    libgstrtspserver-1.0-0 \
    libjansson4 \
    libjson-glib-1.0-0 \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

## Additional DeepStream dependencies usually installed by the CUDA Toolkit

RUN apt-get update && \
    apt-get install -y \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# DeepStream

COPY ./deepstream-4.0_4.0-1_arm64.deb /deepstream-4.0_4.0-1_arm64.deb
RUN dpkg -i /deepstream-4.0_4.0-1_arm64.deb && \
    rm /deepstream-4.0_4.0-1_arm64.deb
RUN export LD_LIBRARY_PATH=/usr/lib/aarch64-linux-gnu/tegra:$LD_LIBRARY_PATH
RUN ldconfig
WORKDIR /opt/nvidia/deepstream/deepstream-4.0/samples
