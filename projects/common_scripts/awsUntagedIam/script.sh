#!/bin/bash


## If the resousece name containce hds make it lower 
# Name =~ HDS 


## When AWS resources doesn't have folowing tags 
# ApplicationID = APP0002139
# Owner = us-l3globalhomedelivery@us.mcd.com
# GBL  = 195500762302



aws ec2 describe-images \
  --output text \
  --filters Name=instance-state-name,Values=running 