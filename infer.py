from diffusers import StableDiffusionPipeline
import torch

model_id = "/home/ec2-user/src/data-dir/model/1200"
pipe = StableDiffusionPipeline.from_pretrained(model_id, torch_dtype=torch.float16).to("cuda")

prompt = "a photo of kieran in the hogwarts great hall who is in the slytherin house"
image = pipe(prompt, num_inference_steps=50, guidance_scale=7.5).images[0]

image.save("/home/ec2-user/src/kieran-stuff/image.png")
