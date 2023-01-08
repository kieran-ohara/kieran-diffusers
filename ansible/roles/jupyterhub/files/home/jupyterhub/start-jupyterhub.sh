#!/bin/sh

source /opt/conda/etc/profile.d/conda.sh
conda activate jupyterhub
jupyterhub --config ./jupyterhub_config.py
