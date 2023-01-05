#!/bin/bash -xe

# Git
sudo yum install -y git

# I want my physical computer to sleep while the training goes on.
sudo yum install -y tmux

# yum-config-mgr
sudo yum install -y yum-utils

# To build CUDA
sudo yum install -y centos-release-scl
sudo yum install -y devtoolset-7-gcc*
sudo yum install -y kernel-devel-$(uname -r) kernel-headers-$(uname -r)

# To view devices
sudo yum install -y pciutils
