# AWS Notes

<!-- toc -->

----

This page contains a collection of unrelated notes pertaining to AWS.

## Assume-role script

Set the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`, or the `AWS_PROFILE` environment variables to the user that should assume a role.
Set `ROLE_ARN` to the Arn of the role being assumed. Finally, create a "command line" build step.

```shell
export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" \
    $(aws sts assume-role \
        --role-arn "${ROLE_ARN}" \
        --role-session-name "${USER}" \
        --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" \
        --output text))
```

## Bulk log retention update in Powershell

This sets log retention to 1 day for all Airship lambdas.

```powershell
$logGroups=(aws logs describe-log-groups --log-group-name-prefix "/aws/lambda" --query "logGroups[*].logGroupName" --output=text).Split() `
    | where {$_ -match 'lambda-lookup'} 
foreach ($logGroupName in $logGroups) {
    aws logs put-retention-policy --log-group-name $logGroupName --retention-in-days 1
}
```

## ECS on spot instances

* [Docker, Amazon ECS, and Spot Fleets: A Great Fit Together](https://aws.amazon.com/blogs/aws/docker-amazon-ecs-and-spot-fleets-a-great-fit-together/)
* [Auto Scaling Groups with Multiple Instance Types and Purchase Options](https://docs.aws.amazon.com/autoscaling/ec2/userguide/asg-purchase-options.html)
* [Launching Spot Instances in Your Auto Scaling Group](https://docs.aws.amazon.com/autoscaling/ec2/userguide/asg-launch-spot-instances.html)
* Terraform `mixed_instances_policy` for [`aws_autoscaling_group`](https://www.terraform.io/docs/providers/aws/r/autoscaling_group.html)
* [ECS Spot Fleet Demo](https://github.com/tongueroo/ecs-spot-demo) (with drain script userdata)

## Teamcity AWS assume role

Set the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables to the user that should assume a role. Set `ROLE_ARN` to the Arn of the role being assumed. Finally, create a "command line" build step that runs in the "alpine:latest" Docker container.

```shell
apk add jq
CREDENTIALS=$(aws sts assume-role --role-arn $ROLE_ARN --role-session-name teamcity  --duration-seconds 900)
mkdir - ~/.aws
echo "##teamcity[setParameter name='AWS_ACCESS_KEY_ID' value='$(echo $CREDENTIALS | jq -r .Credentials.AccessKeyId)']"
echo "##teamcity[setParameter name='AWS_SECRET_ACCESS_KEY' value='$(echo $CREDENTIALS | jq -r .Credentials.SecretAccessKey)']"
echo "##teamcity[setParameter name='AWS_SESSION_TOKEN' value='$(echo $CREDENTIALS | jq -r .Credentials.SessionToken)']"
```

## Cross account roles

Example: <https://jackiechen.org/2015/11/03/ec2-instance-cannot-assume-role-in-other-accounts/>

## EC2 instance metadata

Get metadata list:

```text
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
```

Get specific metadata, e.g `instance-id`:

```text
$ wget -q -O- http://169.254.169.254/latest/meta-data/instance-id
i-08820e8f284ffa01a
```

Source: <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html>

## Lambda

* Deployment management: [Apex](http://apex.run/)
