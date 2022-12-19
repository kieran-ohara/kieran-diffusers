#!/bin/env python

from PIL import Image
from diffusers import StableDiffusionPipeline
from string import Template
import os
import torch

SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))
PROJECT_ROOT = SCRIPT_DIR+"/.."
MODEL_DIR = f'{PROJECT_ROOT}/model';

def script_dir():
    return SCRIPT_DIR

def interpolate_prompt(prompt_template, **kwargs):
    template = Template(prompt_template)
    return  template.substitute(**kwargs)

def get_pipeline(MODEL_NAME):

    model_id = f'{PROJECT_ROOT}/model/{MODEL_NAME}'
    pipe = StableDiffusionPipeline.from_pretrained(
        model_id,
        torch_dtype=torch.float16,
    )
    cuda_pipe = pipe.to("cuda")
    return cuda_pipe

def image_grid(imgs, rows, cols):
    assert len(imgs) == rows*cols

    w, h = imgs[0].size
    grid = Image.new('RGB', size=(cols*w, rows*h))
    grid_w, grid_h = grid.size

    for i, img in enumerate(imgs):
        grid.paste(img, box=(i%cols*w, i//cols*h))
    return grid

def output_path(MODEL_NAME):
    output_path = f'{MODEL_DIR}/{MODEL_NAME}/output'
    isExist = os.path.exists(output_path)
    if not isExist:
        os.makedirs(output_path)
    return output_path

def model_info(model_name):
    f = open(f'{MODEL_DIR}/{model_name}')
    data = json.loads(f)
    f.close()
    return data
