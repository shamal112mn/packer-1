#!/bin/bash



aws ec2 describe-instances \
  --output text \
  --filters Name=instance-state-name,Values=running \
  --query 'Reservations[].Instances[?!not_null(Tags[?Key == `Owner`].Value)] | [].[InstanceId]'