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
    launch_type = "FARGATE"
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

# resource "aws_iam_role" "iic_backed_task_exec_role" {
#     name = "iic-backend-task-exec-role"
#     assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
# }

# put it all together
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
    role = aws_iam_role.iic_backed_task_exec_role.name
    policy_arn = data.aws_iam_policy.ecs_task_execution_role.arn
}