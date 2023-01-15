# Deploy

The following instructions assume you have a Google Cloud Platform account.
(I started out with AWS but it turns out you get
[more for your money](../reference/gpus.md) with GCP).

## Prerequisites

- [Packer](https://www.packer.io/)
- [Terraform](https://www.terraform.io/)
- A GCP service account.

## 1. Build Image

The software needs to be configured
[just so](../reference/software-hardware-stack.md) to run Stable Diffusion.

Follow these steps to let me do that for you:

1. `cd` into the `infrastructure/build` folder.
2. Copy `./build.pkvars.hcl` to `./build.auto.pkrvars.hcl`; setting the
   variables as appropriate.
3. Build the image via `$ packer build .`. Note you will have to auth
   Packer with GCP via your [preferred means](https://developer.hashicorp.com/packer/plugins/builders/googlecompute#authentication).
