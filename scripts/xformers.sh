#!/bin/bash -xe

# 8.6 for A10, 7.5 for T4. This can take some time.
# see https://developer.nvidia.com/cuda-gpus
ARCH=$1

if [ -z "$ARCH" ]
then
  echo "Please specify arch."
      return 1
fi

eval "$(/"${HOME}"/anaconda3/bin/conda shell.bash hook)"
source "/"${HOME}"/anaconda3/etc/profile.d/conda.sh"

git clone https://github.com/facebookresearch/xformers.git ~/src/xformers
cd ~/src/xformers
git submodule update --init --recursive
pip install -r requirements.txt --no-cache-dir
# CUDA_HOME=/usr/local/cuda TORCH_CUDA_ARCH_LIST=$ARCH FORCE_CUDA="1" pip install -e .
