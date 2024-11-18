#!/bin/bash

# get_first_vpc_id.sh
VPC_NAME=$1
aws ec2 describe-vpcs --filters "Name=tag:Name,Values=${VPC_NAME}" --query "Vpcs[0].VpcId" --output text
