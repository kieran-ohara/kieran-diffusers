#!/bin/env python

import util

MODEL_NAME = "1200"

pipe = util.get_pipeline(MODEL_NAME)
with open(f'{util.script_dir()}/prompts.txt') as file:
    prompts = [util.interpolate_prompt(line, instance='kokieran man') for line in file]
    num_images_per_prompt = 1

    images = pipe(
        prompts,
        num_inference_steps=50,
        num_images_per_prompt=num_images_per_prompt,
        guidance_scale=7.5)

    grid = util.image_grid(images.images, len(prompts), num_images_per_prompt)
    grid.save(f'{util.output_path(MODEL_NAME)}.png')
