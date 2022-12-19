#!/bin/env python

from diffusers import StableDiffusionPipeline
from string import Template
import torch
import os


SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))
PROJECT_ROOT = SCRIPT_DIR+"/.."

def output_path(model_name):
    output_path = f'{SCRIPT_DIR}/output/{model_name}'
    isExist = os.path.exists(output_path)
    if not isExist:
        os.makedirs(output_path)
    return output_path

def get_pipeline(model_name):
    model_id = f'{PROJECT_ROOT}/model/{model_name}'
    pipe = StableDiffusionPipeline.from_pretrained(
        model_id,
        torch_dtype=torch.float16
    )
    cuda_pipe = pipe.to("cuda")
    return cuda_pipe


model_name = "1200"
pipe = get_pipeline(model_name)

i = 0;
with open(f'{SCRIPT_DIR}/prompts.txt') as prompts:
    for prompt_template in prompts:
        template = Template(prompt_template)
        prompt = template.substitute(instance='kokieran man')
        image = pipe(
            prompt,
            num_inference_steps=50,
            guidance_scale=7.5).images[0]
        image.save(f'{output_path(model_name)}/image{i}.png')
        i = i+1
