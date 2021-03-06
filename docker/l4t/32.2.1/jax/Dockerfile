ARG VERSION_ID
ARG DEPENDENCIES_IMAGE
ARG IMAGE_NAME
FROM ${DEPENDENCIES_IMAGE} as dependencies

ARG VERSION_ID
# using a smaller image doesn't save us any space as the layers are used by the other images.
FROM ubuntu:${VERSION_ID} as qemu

# install qemu for the support of building containers on host
RUN apt-get update && apt-get install -y --no-install-recommends qemu-user-static && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# start of the real image base
ARG VERSION_ID
FROM arm64v8/ubuntu:${VERSION_ID}

ARG DRIVER_PACK=Jetson_Linux_R32.2.1_aarch64.tbz2

# pre-req qemu binary for aarch64 emulation if this container image is built directly on x86 host
COPY --from=qemu /usr/bin/qemu-aarch64-static /usr/bin/qemu-aarch64-static

ARG DEPENDENCIES_IMAGE
COPY --from=dependencies /data/${DRIVER_PACK} ${DRIVER_PACK}
RUN apt-get update && apt-get install -y --no-install-recommends \
    bzip2 \
    lbzip2 \
    sudo \
    && \
    echo "47a7b43f119888f7506a6ff447f43036 *./${DRIVER_PACK}" | md5sum -c - && \
    tar -xpj --overwrite -f ./${DRIVER_PACK} && \
    sed -i '/.*tar -I lbzip2 -xpmf ${LDK_NV_TEGRA_DIR}\/config\.tbz2.*/c\tar -I lbzip2 -xpm --overwrite -f ${LDK_NV_TEGRA_DIR}\/config.tbz2' ./Linux_for_Tegra/apply_binaries.sh && \
    ./Linux_for_Tegra/apply_binaries.sh -r / && \
    rm -rf ./Linux_for_Tegra && \
    rm ./${DRIVER_PACK} \
    && \
    apt-get purge --autoremove -y bzip2 lbzip2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV LD_LIBRARY_PATH=/usr/lib/aarch64-linux-gnu/tegra:/usr/lib/aarch64-linux-gnu/tegra-egl:${LD_LIBRARY_PATH}

RUN ln -s /usr/lib/aarch64-linux-gnu/tegra/libnvidia-ptxjitcompiler.so.32.2.1 /usr/lib/aarch64-linux-gnu/tegra/libnvidia-ptxjitcompiler.so
RUN ln -s /usr/lib/aarch64-linux-gnu/tegra/libnvidia-ptxjitcompiler.so.32.2.1 /usr/lib/aarch64-linux-gnu/tegra/libnvidia-ptxjitcompiler.so.1
RUN ln -s /usr/lib/aarch64-linux-gnu/libcuda.so /usr/lib/aarch64-linux-gnu/libcuda.so.1
RUN ldconfig
