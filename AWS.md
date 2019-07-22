# Misc. Notes

This page contains a collection of unrelated notes pertaining to AWS.

## ECS on spot instances

* [Docker, Amazon ECS, and Spot Fleets: A Great Fit Together](https://aws.amazon.com/blogs/aws/docker-amazon-ecs-and-spot-fleets-a-great-fit-together/)
* [Auto Scaling Groups with Multiple Instance Types and Purchase Options](https://docs.aws.amazon.com/autoscaling/ec2/userguide/asg-purchase-options.html)
* [Launching Spot Instances in Your Auto Scaling Group](https://docs.aws.amazon.com/autoscaling/ec2/userguide/asg-launch-spot-instances.html)
* Terraform `mixed_instances_policy` for [`aws_autoscaling_group`](https://www.terraform.io/docs/providers/aws/r/autoscaling_group.html)
* [ECS Spot Fleet Demo](https://github.com/tongueroo/ecs-spot-demo) (with drain script userdata)

## Assume-role script

Install `jq`. Set the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables to the user that should assume a role. Set `ROLE_ARN` to the Arn of the role being assumed. Finally, create a "command line" build step.

```bash
CREDENTIALS=$(aws sts assume-role --role-arn $ROLE_ARN --role-session-name teamcity  --duration-seconds 900)
export AWS_ACCESS_KEY_ID=$(echo $CREDENTIALS | jq -r .Credentials.AccessKeyId)
export AWS_SECRET_ACCESS_KEY=$(echo $CREDENTIALS | jq -r .Credentials.SecretAccessKey)
export AWS_SESSION_TOKEN=$(echo $CREDENTIALS | jq -r .Credentials.SessionToken)
echo Expiration: $(echo $CREDENTIALS | jq -r .Credentials.Expiration)
```

## Teamcity AWS assume role

Set the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables to the user that should assume a role. Set `ROLE_ARN` to the Arn of the role being assumed. Finally, create a "command line" build step that runs in the "alpine:latest" Docker container.

```bash
apk add jq
CREDENTIALS=$(aws sts assume-role --role-arn $ROLE_ARN --role-session-name teamcity  --duration-seconds 900)
mkdir - ~/.aws
echo "##teamcity[setParameter name='AWS_ACCESS_KEY_ID' value='$(echo $CREDENTIALS | jq -r .Credentials.AccessKeyId)']"
echo "##teamcity[setParameter name='AWS_SECRET_ACCESS_KEY' value='$(echo $CREDENTIALS | jq -r .Credentials.SecretAccessKey)']"
echo "##teamcity[setParameter name='AWS_SESSION_TOKEN' value='$(echo $CREDENTIALS | jq -r .Credentials.SessionToken)']"
```

## Cross account roles

Example: https://jackiechen.org/2015/11/03/ec2-instance-cannot-assume-role-in-other-accounts/

## EC2 instance metadata

Get metadata list:

    $ wget -q -O- http://169.254.169.254/latest/meta-data
    ami-id
    ami-launch-index
    ami-manifest-path
    block-device-mapping/
    hostname
    iam/
    instance-action
    instance-id
    instance-type
    local-hostname
    local-ipv4
    mac
    metrics/
    network/
    placement/
    profile
    public-keys/
    reservation-id
    security-groups
    services/

Get specific metadata, e.g `instance-id`:

    $ wget -q -O- http://169.254.169.254/latest/meta-data/instance-id
    i-08820e8f284ffa01a

Source: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html

## Lambda

* Deployment management: [Apex](http://apex.run/)

[gimmick:Disqus](swissarmyronin-github-io)