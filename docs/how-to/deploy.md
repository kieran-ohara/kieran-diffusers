# Deploy

Fair warns: the CDK script starts up a `g4dn` instance; they cost over $0.5 p/h
so stop the instance when not in use!

1. Copy and customize contents of `varfile.example.json` for your personal
   setup.
   - CUDA driver only worked on Kernel v4.
2. Build the AMI via
   [Packer](https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli):
   - For GCP, use
     `$ packer build -var-file 'varfile.json' -only 'rhel7_vm.googlecompute.*' .`
   - For AWS, use
     `$ packer build -var-file 'varfile.json' -only 'rhel7_vm.amazon-ebs.*' .`
     Take note of the AMI ID that is created.
3. Set the value of `context.euWestAMI` in `./cdk.json` to the AMI ID from
   previous step.
4. Deploy the infrastructure: `$ npm install && npx cdk deploy StableDiffusion`.
   You will need to modify for your own VPC.
