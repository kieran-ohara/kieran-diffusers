#!/bin/bash -e

source "/"${HOME}"/anaconda3/etc/profile.d/conda.sh"
conda activate sd

# Diffusers fork that runs on GPU < 16G
git clone https://github.com/ShivamShrirao/diffusers.git ~/src/diffusers
cd ~/src/diffusers
pip install -e .
cd examples/dreambooth
pip install -q -U --pre triton
pip install -q accelerate==0.12.0 transformers ftfy bitsandbytes gradio natsort

# This repo. Hey.
git clone https://github.com/kieran-ohara/kieran-diffusers ~/src/kieran-diffusers
