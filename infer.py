from diffusers import StableDiffusionPipeline
import torch
import os

model_name = "4002"
model_id = os.getcwd()+"/model/"+model_name

prompt = "kokieran man rides a bike, high definition, space, photo realistic, waterpaint"
dir = model_name
path = os.getcwd()+"/output/"+dir

pipe = StableDiffusionPipeline.from_pretrained(
    model_id,
    torch_dtype=torch.float16).to("cuda")


isExist = os.path.exists(path)
if not isExist:
   os.makedirs(path)

for n in range(20):
    image = pipe(
        prompt,
        num_inference_steps=50,
        guidance_scale=7.5).images[0]
    image.save(path+"/image"+str(n)+".png")
