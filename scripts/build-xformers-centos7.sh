#!/bin/bash -e

# 8.6 for A10, 7.5 for T4. This can take some time.
# see https://developer.nvidia.com/cuda-gpus
if [ -z "$ARCH" ]
then
  echo "Please specify arch."
      return 1
fi

eval "$(/"${HOME}"/anaconda3/bin/conda shell.bash hook)"
source "/"${HOME}"/anaconda3/etc/profile.d/conda.sh"
conda activate sd

cd ~/src/xformers
source /opt/rh/devtoolset-7/enable
CUDA_HOME=/usr/local/cuda TORCH_CUDA_ARCH_LIST=$ARCH pip install -e .
