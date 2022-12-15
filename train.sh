#!/bin/bash
SRC="${HOME}/src"
THIS=$(pwd)
DREAMBOOTH="${SRC}/Shivan-diffusers/examples/dreambooth"

export MODEL_NAME="CompVis/stable-diffusion-v1-4"
export INSTANCE_DIR="${THIS}/instances/kieran"
export CLASS_DIR="${THIS}/class/people"
export OUTPUT_DIR="${THIS}/model"

cd $DREAMBOOTH && accelerate launch train_dreambooth.py \
  --pretrained_model_name_or_path=$MODEL_NAME  \
  --instance_data_dir=$INSTANCE_DIR \
  --class_data_dir=$CLASS_DIR \
  --output_dir=$OUTPUT_DIR \
  --with_prior_preservation --prior_loss_weight=1.0 \
  --instance_prompt="a photo of kieran" \
  --class_prompt="a photo of a man" \
  --resolution=512 \
  --train_batch_size=1 \
  --gradient_accumulation_steps=1 \
  --learning_rate=5e-6 \
  --lr_scheduler="constant" \
  --lr_warmup_steps=0 \
  --num_class_images=200 \
  --max_train_steps=1200 \
  --gradient_checkpointing \
  --mixed_precision=fp16
