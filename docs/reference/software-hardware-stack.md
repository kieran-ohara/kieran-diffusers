# Software/Hardware Stack

```mermaid
graph TD;

    linux[Linux Kernel v4]
    

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
    
    subgraph NVIDIA
        gpu[NVIDIA GPU]
        cuda[CUDA]
        linux_module[Linux Module nvidia.ko]
    end

    train --> model

    model --> diffusers_pipe
    diffusers_pipe --> diffusers
    diffusers --> pytorch
    pytorch --> cuda
    cuda --> linux_module
    linux_module --> linux
    linux --> gpu
```
