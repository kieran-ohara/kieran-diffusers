#!/bin/bash
SRC="${HOME}/src"
THIS=$(pwd)
DREAMBOOTH="${THIS}/submodules/diffusers/examples/dreambooth"

export MODEL_NAME="CompVis/stable-diffusion-v1-4"
export INSTANCE_DIR="${THIS}/instances/kieran3"
export NUM_INSTANCES=228
export CLASS_DIR="${THIS}/data/class/man${NUM_INSTANCES}"
export OUTPUT_DIR="${THIS}/model"

cd $DREAMBOOTH && accelerate launch train_dreambooth.py \
  --pretrained_model_name_or_path=$MODEL_NAME  \
  --instance_data_dir=$INSTANCE_DIR \
  --class_data_dir=$CLASS_DIR \
  --output_dir=$OUTPUT_DIR \
  --with_prior_preservation \
  --prior_loss_weight=1.0 \
  --instance_prompt="kokieran" \
  --class_prompt="man" \
  --resolution=512 \
  --train_batch_size=1 \
  --gradient_accumulation_steps=1 \
  --learning_rate=1e-6 \
  --lr_scheduler="constant" \
  --lr_warmup_steps=0 \
  --num_class_images=$NUM_INSTANCES \
  --max_train_steps=1520 \
  --gradient_checkpointing \
  --mixed_precision=fp16 \
  --use_8bit_adam
