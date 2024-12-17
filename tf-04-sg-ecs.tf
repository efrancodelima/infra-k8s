resource "aws_security_group" "tf_ecs_sg" {
  name   = "lanchonete-ecs-serv-sg"
  vpc_id = data.aws_vpc.tf_vpc.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_groups = [aws_security_group.tf_lb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [aws_security_group.tf_lb_sg]
}
