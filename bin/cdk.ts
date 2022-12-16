import 'source-map-support/register';
import * as cdk from "aws-cdk-lib";
import StableDiffusion from "../lib/stacks/stable-diffusion";

const envs = {
  london: {
    account: process.env.CDK_DEFAULT_ACCOUNT,
    region: "eu-west-2",
  },
};

const app = new cdk.App();

new StableDiffusion(app, "StableDiffusion", {
  env: envs.london,
});

app.synth();
