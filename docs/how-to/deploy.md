# Deploy

Fair warns: the CDK script starts up a `g4dn` instance; they cost over $0.5 p/h
so stop the instance when not in use!

1. Update the SSH configuration in `./build.pkr.hcl` to suit your personal
   setup.
2. Build the AMI via
   [Packer](https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli):
   `$ packer build -only 'ami.*' .` Take note of the AMI ID that is created.
3. Set the value of `context.euWestAMI` in `./cdk.json` to the AMI ID from
   previous step.
4. Deploy the infrastructure: `$ npm install && npx cdk deploy StableDiffusion`.
   You will need to modify for your own VPC.
