import { Construct } from "constructs";
import * as cdk from "aws-cdk-lib";
import * as ec2 from 'aws-cdk-lib/aws-ec2'

interface StableDiffusionProps extends cdk.StackProps {}

export default class StableDiffusion extends cdk.Stack {
  constructor(scope: Construct, id: string, props:  StableDiffusionProps) {
    super(scope, id, props);

    const vpc = ec2.Vpc.fromVpcAttributes(this, 'irevpc', {
      vpcId: 'vpc-061a44533aa206b2e',
      availabilityZones:[
        'eu-west-1',
        'eu-west-2',
        'eu-west-3',
      ]
    })

    const availabilityZone = `${cdk.Stack.of(this).region}a`;

    const securityGroup = new ec2.SecurityGroup(this, 'web-server-sg', {
      vpc,
      allowAllOutbound: true,
      description: 'security group for a web server',
    });
    securityGroup.addIngressRule(
      ec2.Peer.anyIpv4(),
      ec2.Port.tcp(22),
      'allow SSH access from anywhere',
    );

    const provisionSpaceForDiffusionModelCount = 5;
    const provisionSizesGb  = {
      "condaEnvSize" : 12,
      "condaLibSize" : 4,
      "stableDiffusionCkptSize" : 6,
      "diffuserModelSize" : 4 * provisionSpaceForDiffusionModelCount,
      "cudaSize" : 9,
      "githubSrcPadding" : 1,
      "linuxPadding" : 16,
    }

    const ebsSize = Object.values(provisionSizesGb).reduce((prev, current) => prev + current, 0)

    const instance = new ec2.Instance(this, 'Instance', {
      machineImage: new ec2.AmazonLinuxImage({
        generation: ec2.AmazonLinuxGeneration.AMAZON_LINUX_2,
        edition: ec2.AmazonLinuxEdition.STANDARD,
        virtualization: ec2.AmazonLinuxVirt.HVM,
        storage: ec2.AmazonLinuxStorage.GENERAL_PURPOSE,
      }),
      instanceType: new ec2.InstanceType('g4dn.xlarge'),
      keyName: 'kieranohara',
      vpc,
      vpcSubnets: {
        subnets: [
          ec2.Subnet.fromSubnetAttributes(this, 'test', {
            subnetId: 'subnet-00090ff0d1dde872e',
            availabilityZone,
          })
        ]
      },
      securityGroup,
      blockDevices:[
        {
          deviceName: '/dev/xvda',
          volume: ec2.BlockDeviceVolume.ebs(ebsSize),
        },
      ],
    })

    const eip = new ec2.CfnEIP(this, 'eip', {
      instanceId: instance.instanceId
    })
  }
}