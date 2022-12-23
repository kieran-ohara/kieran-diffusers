#!/bin/bash -xe

# Git
sudo yum install -y git

# CUDA
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum-config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-rhel7.repo
sudo yum clean expire-cache
sudo yum -y install nvidia-driver-latest-dkms
sudo yum -y install cuda-11.7.1-1
sudo yum -y install cuda-drivers

# Conda
sudo yum install -y libXcomposite libXcursor libXi libXtst libXrandr alsa-lib mesa-libEGL libXdamage mesa-libGL libXScrnSaver
curl -L https://repo.anaconda.com/archive/Anaconda3-2022.10-Linux-x86_64.sh -o install-conda.sh
chmod 755 install-conda.sh
./install-conda.sh -bu
rm install-conda.sh
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
# 8.6 for A10, 7.5 for T4. This can take some time.
CUDA_HOME=/usr/local/cuda TORCH_CUDA_ARCH_LIST=7.5 pip install -e .

# Alacritty Terminals
cd ~/
curl -L https://raw.githubusercontent.com/alacritty/alacritty/master/extra/alacritty.info > alacritty.info
sudo tic -xe alacritty,alacritty-direct alacritty.info
rm alacritty.info

# Diffusers fork that runs on GPU < 16G
git clone https://github.com/ShivamShrirao/diffusers.git ~/src/diffusers
cd ~/src/diffusers
pip install -e .
cd examples/dreambooth
pip install -q -U --pre triton
pip install -q accelerate==0.12.0 transformers ftfy bitsandbytes gradio natsort

# This repo. Hey.
git clone https://github.com/kieran-ohara/kieran-diffusers ~/src/kieran-diffusers

# etc.
sudo yum install -y tmux #b/c I want my physical computer to sleep while the training goes on.

sudo amazon-linux-extras install epel -y
sudo yum install -y ncdu
