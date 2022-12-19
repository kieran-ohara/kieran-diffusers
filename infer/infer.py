#!/bin/env python

import util
import torch
import argparse

if __name__ == "__main__":
    print("Hello, World!")

    parser = argparse.ArgumentParser(
                        prog = 'ProgramName',
                        description = 'What the program does',
                        epilog = 'Text at the bottom of help')
    parser.add_argument('model')
    parser.add_argument('-l', '--learningrate')
    args = parser.parse_args()

    pipe = util.get_pipeline(args.model)

    with open(f'{util.script_dir()}/prompts.txt') as file:
        prompts = [util.interpolate_prompt(line, instance='kokieran man') for line in file]
        num_images_per_prompt = 5

        generator = torch.Generator("cuda").manual_seed(1024)
        images = pipe(
            prompts,
            num_inference_steps=50,
            num_images_per_prompt=num_images_per_prompt,
            guidance_scale=7.5,
            generator=generator
        )

        grid = util.image_grid(images.images, len(prompts), num_images_per_prompt)
        grid.save(f'{util.output_path(args.model)}/image.png')
