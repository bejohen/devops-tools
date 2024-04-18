resource "aws_autoscaling_group" "ecs_autoscaling_group" {
  name                 = "ecs-autoscaling-group"
  min_size             = 2
  max_size             = 2
  desired_capacity     = 2
  vpc_zone_identifier  = local.public_subnets  # Replace with your subnet ID
    tag {
    key                 = "Name"
    value               = "ecs-instance"
    propagate_at_launch = true
  }
  launch_template {
    id      = aws_launch_template.ecs_ec2.id
    version = "$Latest"
  }
}