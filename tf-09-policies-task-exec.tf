resource "aws_iam_role_policy_attachment" "tf_ecs_task_exec_policy_ter" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.tf_ecs_task_exec_role.name

  depends_on = [
    aws_iam_role.tf_ecs_task_exec_role
  ]
}

resource "aws_iam_role_policy_attachment" "tf_ecs_task_exec_policy_cw" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  role       = aws_iam_role.tf_ecs_task_exec_role.name

  depends_on = [
    aws_iam_role.tf_ecs_task_exec_role
  ]
}
