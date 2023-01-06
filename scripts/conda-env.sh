#!/bin/bash -e

# Conda
curl -L https://repo.anaconda.com/archive/Anaconda3-2022.10-Linux-x86_64.sh -o install-conda.sh
chmod 755 install-conda.sh
./install-conda.sh -bu
rm install-conda.sh
eval "$(/"${HOME}"/anaconda3/bin/conda shell.bash hook)"
conda init

# Conda Env
source "/"${HOME}"/anaconda3/etc/profile.d/conda.sh"
conda create -y -n sd python=3.10
conda activate sd

conda install -y pytorch torchvision torchaudio pytorch-cuda=11.7 -c pytorch -c nvidia
