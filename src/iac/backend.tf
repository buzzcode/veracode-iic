#
resource "aws_ecs_service" "backend-server" {
    name = var.backend_service_name
    task_definition = ""
    launch_type = "FARGATE"
}