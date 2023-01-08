#!/bin/bash

# Parameters
INSTANCES=$1
INSTANCE_PROMPT=$2
CLASS_PROMPT=$3
CLASS_COUNT=$4
LEARNING_RATE=$5
TRAINING_STEPS=$6

# Paths
THIS=$(pwd)
PATH_DREAMBOOTH="${THIS}/submodules/diffusers/examples/dreambooth"
PATH_INSTANCES="${THIS}/data/instances/${INSTANCES}"
PATH_CLASS="${THIS}/data/class/${CLASS_PROMPT}/${CLASS_COUNT}"

OUTPUT_DIR="${THIS}/model"

cd "${PATH_DREAMBOOTH}" && accelerate launch train_dreambooth.py \
  --pretrained_model_name_or_path="CompVis/stable-diffusion-v1-4"  \
  --instance_data_dir="${PATH_INSTANCES}" \
  --class_data_dir="${PATH_CLASS}" \
  --output_dir="${OUTPUT_DIR}" \
  --with_prior_preservation \
  --prior_loss_weight=1.0 \
  --instance_prompt="${INSTANCE_PROMPT}" \
  --class_prompt="${CLASS_PROMPT}" \
  --resolution=512 \
  --train_batch_size=1 \
  --gradient_accumulation_steps=1 \
  --learning_rate="${LEARNING_RATE}" \
  --lr_scheduler="constant" \
  --lr_warmup_steps=0 \
  --num_class_images="${CLASS_COUNT}" \
  --max_train_steps="${TRAINING_STEPS}" \
  --gradient_checkpointing \
  --mixed_precision=fp16 \
  --use_8bit_adam
