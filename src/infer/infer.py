#!/bin/env python

import argparse
import os
import torch

from diffusers import StableDiffusionPipeline
from string import Template

from image_grid import image_grid

SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))
PROJECT_ROOT = SCRIPT_DIR+"/../.."
MODEL_DIR = f'{PROJECT_ROOT}/src/train/model';

def script_dir():
    return SCRIPT_DIR

def interpolate_prompt(prompt_template, **kwargs):
    template = Template(prompt_template)
    return  template.substitute(**kwargs)

def get_pipeline(MODEL_NAME):
    model_id = f'{MODEL_DIR}/{MODEL_NAME}'
    pipe = StableDiffusionPipeline.from_pretrained(
        model_id,
        torch_dtype=torch.float16,
    )
    cuda_pipe = pipe.to("cuda")
    return cuda_pipe

def output_path():
    output_path = f'{SCRIPT_DIR}/output'
    isExist = os.path.exists(output_path)
    if not isExist:
        os.makedirs(output_path)
    return output_path

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('model')
    parser.add_argument('-p', '--prompts', default="prompts")
    args = parser.parse_args()

    pipe = get_pipeline(args.model)

    with open(f'{SCRIPT_DIR}/prompts/{args.prompts}.txt') as file:
        prompts = [interpolate_prompt(line, instance='kokieran man') for line in file]
        num_images_per_prompt = 5

        generator = torch.Generator("cuda").manual_seed(1024)
        images = pipe(
            prompts,
            num_inference_steps=50,
            num_images_per_prompt=num_images_per_prompt,
            guidance_scale=7.5,
            generator=generator
        )

        grid = image_grid(images.images, len(prompts), num_images_per_prompt)
        grid.save(f'{output_path()}/{args.prompts}.png')
