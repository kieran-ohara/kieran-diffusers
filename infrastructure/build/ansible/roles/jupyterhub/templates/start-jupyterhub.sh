#!/bin/sh

source /opt/conda/etc/profile.d/conda.sh
conda activate jupyterhub
exec jupyterhub --config /etc/jupyterhub/jupyterhub_config.py
