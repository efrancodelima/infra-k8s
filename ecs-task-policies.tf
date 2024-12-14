resource "aws_iam_role_policy_attachment" "tf_ecs_task_policy_rds" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
  role       = aws_iam_role.tf_ecs_task_role.name
}

resource "aws_iam_role_policy_attachment" "tf_ecs_task_policy_rds_data" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSDataFullAccess"
  role       = aws_iam_role.tf_ecs_task_role.name
}
