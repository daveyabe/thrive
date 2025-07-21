# Create an IAM role - ecsTaskExecutionRole  
data "aws_iam_policy" "ecsTaskExecutionRolePolicy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
data "aws_iam_policy_document" "ecsExecutionRolePolicy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecsExecutionRolePolicy.json
}
resource "aws_iam_role_policy_attachment" "ecsTaskExecutionPolicy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = data.aws_iam_policy.ecsTaskExecutionRolePolicy.arn
}


# Create cloudWatch Log Group
resource "aws_cloudwatch_log_group" "log" {
  name              = "/${var.ecs_cluster_name}/hellonodejsapp"
  retention_in_days = 14
}

# Create an ECS cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs_cluster_name

  tags = merge(var.common_tags, {
    Name = "${var.naming_prefix}-ecs-cluster"
  })
}

# Create an ECS TD
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family             = "my-ecs-task"
  network_mode       = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([
    {
      name      = "hello-nodejs-app"
      image     = "015042944066.dkr.ecr.us-east-2.amazonaws.com/thrive-demo"
      cpu       = 1024
      memory    = 2048
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.log.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "hellonodejsapp"
        }
      }
    }
  ])
}

# ECS Service 
resource "aws_ecs_service" "ecs_service" {
  name                               = "my-ecs-service"
  cluster                            = aws_ecs_cluster.ecs_cluster.id
  task_definition                    = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count                      = 4
  launch_type     = "FARGATE"
  platform_version = "1.4.0"

  lifecycle {
    ignore_changes = [
      desired_count]
  }
  
  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [var.security_group_ecs]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "hello-nodejs-app"
    container_port   = 3000
  }
}
