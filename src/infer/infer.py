#!/bin/env python

import argparse
import os
import torch

from diffusers import StableDiffusionPipeline
from string import Template

from image_grid import image_grid

SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))

def script_dir():
    return SCRIPT_DIR

def interpolate_prompt(prompt_template, **kwargs):
    template = Template(prompt_template)
    return  template.substitute(**kwargs)

def get_pipeline():
    PROJECT_ROOT = SCRIPT_DIR+"/../.."
    model = f'{PROJECT_ROOT}/src/train/modelx';
    print(model)
    pipe = StableDiffusionPipeline.from_pretrained(
        model,
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
    parser.add_argument('-p', '--prompts', default="prompts")
    parser.add_argument('-i', '--instance', default="kokieran")
    args = parser.parse_args()

    pipe = get_pipeline()

    with open(f'{SCRIPT_DIR}/prompts/{args.prompts}.txt') as file:
        prompts = [interpolate_prompt(line, instance=f'{args.instance}') for line in file]
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
