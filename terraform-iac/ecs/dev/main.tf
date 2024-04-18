resource "aws_ecs_cluster" "my_cluster" {
  name = "dev-ecs-cluster"
}

resource "aws_ecs_task_definition" "task_definition" {
  container_definitions    = data.template_file.task_definition_json.rendered # task defination json file location
  family                   = "nginx-task-defination-webservice"            # task name
  network_mode             = "bridge"                                         # network mode awsvpc, brigde
  memory                   = "256"
  cpu                      = "256"
  requires_compatibilities = ["EC2"] # Fargate or EC2
}

data "template_file" "task_definition_json" {
  template = file("task_definition.json")

  vars = {
    CONTAINER_IMAGE = var.container_image
  }
}

resource "aws_ecs_service" "example" {
  name            = "ecs-service-example"
  cluster         = aws_ecs_cluster.my_cluster.name
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1
}

resource "aws_security_group" "ecs_sg" {
  name        = "ecs-sg"
  description = "Security group for ECS"
  vpc_id = local.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.101.35/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- ECS Capacity Provider ---

resource "aws_ecs_capacity_provider" "main" {
  name = "dev-ecs-cluster-cp"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs_autoscaling_group.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 2
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name       = aws_ecs_cluster.my_cluster.name
  capacity_providers = [aws_ecs_capacity_provider.main.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.main.name
    base              = 1
    weight            = 100
  }
}