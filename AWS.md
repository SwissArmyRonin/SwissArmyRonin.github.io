# Misc. Notes

This page contains a collection of unrelated notes pertaining to AWS.

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