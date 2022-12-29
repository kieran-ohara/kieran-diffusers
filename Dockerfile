# This isn't used anywhere—it's just a fail-fast cache for testing provisioning scripts.
# For the actual build, use the Packer file.
FROM --platform=linux/amd64 nvidia/cuda:11.7.1-devel-rockylinux8

# Setup container deps.
ENV HOME=/root
RUN yum install -y sudo

# Copy each script, run it and remove it.
WORKDIR /root

COPY scripts/utils.sh .
RUN ./utils.sh && rm /root/utils.sh

COPY scripts/conda-env.sh .
RUN ./conda-env.sh && rm /root/conda-env.sh

COPY scripts/xformers.sh .
RUN ./xformers.sh 8.6 && rm xformers.sh

# COPY scripts/source-code.sh .
# RUN ./source-code.sh && rm /root/source-code.sh
