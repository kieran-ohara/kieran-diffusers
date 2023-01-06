#!/bin/bash -e
eval "$(/"${HOME}"/anaconda3/bin/conda shell.bash hook)"
source "/"${HOME}"/anaconda3/etc/profile.d/conda.sh"
conda activate sd


git clone https://github.com/facebookresearch/xformers.git ~/src/xformers
cd ~/src/xformers
git submodule update --init --recursive
pip install -r requirements.txt --no-cache-dir
