#
resource "aws_cloudwatch_log_group" "iic_backed_logs" {
    name = "iic-backend"
}

resource "aws_ecs_cluster" "iic_backend" {
    name = "iic-backend"
}

resource "aws_ecs_service" "backend_server" {
    name = var.backend_service_name
    task_definition = aws_ecs_task_definition.backend_server_task.arn
    cluster = aws_ecs_cluster.iic_backend.id
    launch_type = "FARGATE"
    desired_count = 1

    network_configuration {
        assign_public_ip = true

        security_groups = [
            var.ingress_sg,
            var.egress_sg
        ]

        subnets = [
            var.subnet
        ]
    }   

    load_balancer {
        target_group_arn = aws_lb_target_group.iic_lb_group.arn
        container_name = "iic-backend"
        container_port = "5000"
    }
}

resource "aws_ecs_task_definition" "backend_server_task" {
    family = "backend-server-task"

    container_definitions = jsonencode([
        {
            name = "backend-server"
            image = var.backend_image_name
            portMappings = [
                {
                    containerPort = 5000
                    hostPort = 5000
                }
            ]
            logConfiguraration = {
                logDriver = "awslogs"
                options = {
                    awslogs-region = "us-west-1"
                    awslogs-group = "iic-backend"
                }    
            }

        }
    ])

    # Fargate required
    cpu = 256
    memory = 512
    requires_compatibilities = ["FARGATE"]
    network_mode = "awsvpc"

    execution_role_arn = aws_iam_role.iic_backed_task_exec_role.arn
}

#
# IAM setup to allow AWS to run our task
#
data "aws_iam_policy_document" "ecs_task_assume_role" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
            type = "Service"
            identifiers = ["ecs-tasks.amazonaws.com"]
        }
    }
}

resource "aws_iam_role" "iic_backed_task_exec_role" {
    name = "iic-backend-task-exec-role"
    assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

# this is an AWS-managed ARN
data "aws_iam_policy" "ecs_task_execution_role" {
    arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# put it all together
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
    role = aws_iam_role.iic_backed_task_exec_role.name
    policy_arn = data.aws_iam_policy.ecs_task_execution_role.arn
}

# load balancer to allow access
resource "aws_lb_target_group" "iic_lb_group" {
    name = "iic-backend"
    port = 5000
    protocol = "HTTP"
    target_type = "ip"
    vpc_id = var.iic_vpc
  
}

resource "aws_lb" "iic_nlb" {
    name = "iic-nlb"
    internal = false
    load_balancer_type = "network"

    subnets = [var.subnet]

    security_groups = [
        var.ingress_sg,
        var.egress_sg
    ]
}

resource "aws_lb_listener" "iic_nlb_listener" {
    load_balancer_arn = aws_lb.iic_nlb.arn
    port = "80"
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.iic_lb_group.arn
    }
}
