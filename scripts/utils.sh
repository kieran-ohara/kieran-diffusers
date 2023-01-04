#!/bin/bash -xe

# Git
sudo yum install -y git

# I want my physical computer to sleep while the training goes on.
sudo yum install -y tmux

# yum-config-mgr
sudo yum install -y yum-utils

# Or else I have to use Terminal.app.
cd ~/
curl -L https://raw.githubusercontent.com/alacritty/alacritty/master/extra/alacritty.info > alacritty.info
sudo tic -xe alacritty,alacritty-direct alacritty.info
rm alacritty.info

# To build CUDA
sudo yum install -y centos-release-scl
sudo yum install -y devtoolset-7-gcc*
sudo yum install -y kernel-devel-$(uname -r) kernel-headers-$(uname -r)

# To view devices
sudo yum install -y pciutils
