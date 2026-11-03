#!/bin/bash

aws ec2 run-instances --image-id ami-0557a15b87f6559cf --count 3 --instance-type t2.medium --key-name march24 --security-group-ids sg-06a66741c886c9a89 --subnet-id   subnet-06b4dfa2c550896d7  --region us-east-1

#this script creates ec2 instances for you in aws cloud.
#update the following information
#image id
# count :
# instance type
#keypair
#security group id
#subnets
