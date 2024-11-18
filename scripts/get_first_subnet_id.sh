#!/bin/bash

# get_first_subnet_id.sh
SUBNET_NAME=$1
aws ec2 describe-subnets --filters "Name=tag:Name,Values=${SUBNET_NAME}" --query "Subnets[0].SubnetId" --output text
