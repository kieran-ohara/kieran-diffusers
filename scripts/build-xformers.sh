#!/bin/bash -xe

# 8.6 for A10, 7.5 for T4. This can take some time.
# see https://developer.nvidia.com/cuda-gpus
if [ -z "$ARCH" ]
then
  echo "Please specify arch."
      return 1
fi

cd ~/src/xformers
CUDA_HOME=/usr/local/cuda TORCH_CUDA_ARCH_LIST=$ARCH pip install -e .
