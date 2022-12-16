#!/bin/bash -xe

# CUDA
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum-config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-rhel7.repo
sudo yum clean expire-cache
sudo yum -y install nvidia-driver-latest-dkms
sudo yum -y install cuda-11.7.1-1
sudo yum -y install cuda-drivers

# Conda
yum install libXcomposite libXcursor libXi libXtst libXrandr alsa-lib mesa-libEGL libXdamage mesa-libGL libXScrnSaver
curl -L https://repo.anaconda.com/archive/Anaconda3-2022.10-Linux-x86_64.sh -o install-conda.sh
chmod 755 install-conda.sh
./install-conda.sh -bu
ME=$(whoami)
eval "$(/home/${ME}/anaconda3/bin/conda shell.bash hook)"
conda init

# Conda Env
source "/home/ec2-user/anaconda3/etc/profile.d/conda.sh"
conda create -y -n sd python=3.10
conda activate sd

conda install -y pytorch torchvision torchaudio pytorch-cuda=11.7 -c pytorch -c nvidia

git clone https://github.com/facebookresearch/xformers.git ~/src/xformers
cd ~/src/xformers
git submodule update --init --recursive
pip install -r requirements.txt
CUDA_HOME=/usr/local/cuda TORCH_CUDA_ARCH_LIST=8.6 pip install .

# Alacritty Terminals
curl -L https://raw.githubusercontent.com/alacritty/alacritty/master/extra/alacritty.info > ~/alacritty.info
sudo tic -xe alacritty,alacritty-direct alacritty.info

# Git
sudo yum install -y git
