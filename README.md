# Stable Diffusion/Dreambooth

An experiment to get myself into SD via Dreambooth

## Get Started

Fair warns: the CDK script starts up a `g4dn` instance; they cost over $0.5 p/h so stop the instance when not in use!

1. Startup infrastructure (`npm install && npx cdk deploy StableDiffusion`). You will need to modify for your own VPC.
2. Copy `scripts/provision.sh` and run on your instance.

## Map

```mermaid
graph TD;
    gpu[NVIDIA GPU]
    cuda[CUDA]

    subgraph Inference
        model[Pretrained Model]
    end

    subgraph Conda Env
        pytorch[PyTorch]
        xformers[xFormers Library]

        subgraph HuggingFace
            subgraph Diffusers
                train[train_dreambooth.py]
                diffusers[Diffusers Library]
                diffusers_pipe[Diffusers Pipeline]
                attention[attention.py]

                train --> diffusers
            end

            transformers[Transformers Library]
            transformers --> pytorch
        end

        xformers --> pytorch
        attention --> xformers
        attention --> transformers
    end

    subgraph Training
        instances[Training Images / Instances]
        parameters[Parameters]
        instances --> train
        parameters --> train
    end

    train --> model

    model --> diffusers_pipe
    diffusers_pipe --> diffusers
    diffusers --> pytorch
    pytorch --> cuda
    cuda --> gpu
```
