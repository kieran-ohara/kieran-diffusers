from diffusers import StableDiffusionPipeline
import torch
import os


def setup_output_path(model_name):
    output_path = os.getcwd()+"/infer/output/"+model_name
    isExist = os.path.exists(output_path)
    if not isExist:
        os.makedirs(output_path)
    return output_path

def get_pipeline(model_name):
    model_id = os.getcwd()+"/model/"+model_name
    pipe = StableDiffusionPipeline.from_pretrained(
        model_id,
        torch_dtype=torch.float16
    )
    cuda_pipe = pipe.to("cuda")
    return cuda_pipe

model_name = "1200"

output_path = setup_output_path(model_name)
pipe = get_pipeline(model_name)

with open('infer/prompts.txt') as prompts:
    for prompt in prompts:
        image = pipe(
            prompt,
            num_inference_steps=50,
            guidance_scale=7.5).images[0]
        image.save(output_path+"/image.png")
