#!/bin/bash
set -xe

########################################
# OS update
########################################
yum update -y

########################################
# ECS configuration
########################################
cat <<EOF >> /etc/ecs/ecs.config
ECS_CLUSTER=${cluster_name}
ECS_ENABLE_TASK_IAM_ROLE=true
ECS_ENABLE_TASK_IAM_ROLE_NETWORK_HOST=true
ECS_LOGLEVEL=info
EOF

systemctl enable ecs
systemctl start ecs

########################################
# SSM Agent (primary access)
########################################
yum install -y amazon-ssm-agent
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

########################################
# SSH Hardening (fallback via bastion)
########################################
sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd

########################################
# Time sync (AWS API stability)
########################################
yum install -y chrony
systemctl enable chronyd
systemctl start chronyd

########################################
# Diagnostics
########################################
echo "ECS EC2 bootstrap completed at $(date)" > /var/log/ecs-bootstrap.log
