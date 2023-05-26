resource "aws_iam_role" "ecs_task_execution_role" {
  name = "sentinel-deployments-ecsTaskExecutionRole"

  assume_role_policy = <<EOF
    {
      "Version": "2012-10-17",
        "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "ecs-tasks.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
        ]
    }
  EOF
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_cluster" "cluster" {
  name = "sentinel-deployments"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_service" "service" {
  name            = "sentinel-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.id
  deployment_maximum_percent = 200
  deployment_minimum_healthy_percent = 100
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.security-group.id]
    subnets          = [aws_subnet.subnet.id]
  }
}

resource "aws_ecs_task_definition" "task" {
  family                   = "sentinel"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = "arn:aws:iam::920460467289:role/sentinel-deployments-ecsTaskExecutionRole"
  container_definitions = jsonencode([
    {
      name      = "superfluid-sentinel"
      image     = "920460467289.dkr.ecr.eu-central-1.amazonaws.com/superfluid-test-ecr:master-${var.github_sha}"
      cpu       = 265
      memory    = 512
      essential = true
      environment = [
        {
          "name" : "NODE_ENV"
          "value" : var.node_env
        },
        {
          "name" : "DB_PATH"
          "value" : var.db_path
        },
        {
          "name" : "HTTP_RPC_NODE"
          "value" : var.sentinel_http_rpc_node
        },
        {
          "name" : "FASTSYNC"
          "value" : tostring(var.sentinel_fastsync)
        },
        {
          "name" : "OBSERVER"
          "value" : tostring(var.sentinel_observer)
        }
      ]
      mountPoints = [
        {
          "readOnly" : null,
          "containerPath" : "/app/data",
          "sourceVolume" : "efs_temp"
        }
      ]
    }
  ])
  volume {
    name = "efs_temp"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.efs_volume.id
      root_directory = "/"
    }
  }
}
