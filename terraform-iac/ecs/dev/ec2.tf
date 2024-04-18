# resource "aws_launch_configuration" "ecs_launch_config" {
#   name                 = "ecs-launch-config"
#   image_id             = "ami-0dc44e17251b74325"
#   instance_type        = "t2.micro"
#   security_groups      = [aws_security_group.ecs_sg.id]
#   lifecycle {
#     create_before_destroy = true
#   }
#   iam_instance_profile { arn = aws_iam_instance_profile.ecs_node.arn }


#   user_data = base64encode(<<-EOF
#       #!/bin/bash
#       echo ECS_CLUSTER=${aws_ecs_cluster.my_cluster.name} >> /etc/ecs/ecs.config;
#     EOF
#   )
# }

# --- ECS Launch Template ---
data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }

  owners = ["amazon"]
}

resource "aws_launch_template" "ecs_ec2" {
  name_prefix            = "ecs-launch-template"
  image_id               = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ecs_sg.id]
  key_name               = "ecs-ec2"
  user_data              = base64encode(data.template_file.user_data.rendered)
  iam_instance_profile { arn = aws_iam_instance_profile.ecs_node.arn }
  monitoring { enabled = true }
  
}

data "template_file" "user_data" {
  template = file("user_data.sh")

  vars = {
    ecs_cluster_name = aws_ecs_cluster.my_cluster.name
  }
}
