############################################
# ECS OPTIMIZED AMI
############################################

data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

############################################
# LAUNCH TEMPLATE
############################################

resource "aws_launch_template" "this" {
  name_prefix   = "ecs-ec2-"
  image_id      = data.aws_ssm_parameter.ecs_ami.value
  instance_type = var.instance_type

  iam_instance_profile {
    name = var.instance_profile_name
  }

  vpc_security_group_ids = [var.ecs_sg_id]

  user_data = base64encode(
    templatefile("${path.module}/user_data.sh", {
      cluster_name = var.cluster_name
    })
  )

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 30
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ecs-ec2"
    }
  }
}
