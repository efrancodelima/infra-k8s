resource "aws_iam_role_policy_attachment" "tf_ecs_task_policy_1" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.tf_ecs_task_role.name
}

resource "aws_iam_role_policy_attachment" "tf_ecs_task_policy_2" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  role       = aws_iam_role.tf_ecs_task_role.name
}

resource "aws_iam_role_policy_attachment" "tf_ecs_task_policy_3" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
  role       = aws_iam_role.tf_ecs_task_role.name
}

resource "aws_iam_role_policy_attachment" "tf_ecs_task_policy_4" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSDataFullAccess"
  role       = aws_iam_role.tf_ecs_task_role.name
}
