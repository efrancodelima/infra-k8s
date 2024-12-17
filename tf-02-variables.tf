variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
}

variable "db_url" {
  description = "URL do banco de dados"
  type        = string
}

variable "db_username" {
  description = "Nome de usuário do banco de dados"
  type        = string
}

variable "db_password" {
  description = "Senha do banco de dados"
  type        = string
}

variable "user_pool_id" {
  description = "ID do user pool"
  type        = string
  default     = "us-east-1_QFaugCzHu"
}

variable "up_client_id" {
  description = "ID do client do user pool"
  type        = string
  default     = "4j7fhutokfne6ad9mv5it0d4d7"
}
