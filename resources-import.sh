#!/bin/bash

# Função para importar os recursos passando os parâmetros necessários
import_resource() {
  local resource_type=$1
  local resource_name=$2
  local resource_id=$3

  terraform import \
  -var="aws_account_id=${ACCOUNT_ID}" \
  -var="db_url=${DATASOURCE_URL}" \
  -var="db_username=${DATASOURCE_USERNAME}" \
  -var="db_password=${DATASOURCE_PASSWORD}" \
  "$resource_type.$resource_name" "$resource_id" \
  || echo "Erro ao importar o recurso, continuando..."
}

# Função para pegar o ARN da task definition
get_task_definition_arn() {
  local task_arn=$(aws ecs list-tasks \
    --cluster "lanchonete-ecs-cluster" \
    --query 'taskArns[0]' \
    --output text)
  
  local task_def_arn=$(aws ecs describe-tasks \
    --cluster "lanchonete-ecs-cluster" \
    --tasks "$task_arn" \
    --query 'tasks[0].taskDefinitionArn' \
    --output text)
  
  echo "$task_def_arn"
}

# Constantes
CLUSTER_NAME="lanchonete-ecs-cluster"
SERVICE_NAME="lanchonete-ecs-service"
SECURITY_GROUP_ID="sg-0646521dc971dc12b"

TASK_DEF_ARN=$(get_task_definition_arn)
TASK_ROLE_NAME="lanchonete-ecs-task-execution-role"
TASK_POLICIES=(
  "service-role/AmazonECSTaskExecutionRolePolicy"
  "CloudWatchFullAccess"
  "AmazonRDSFullAccess"
  "AmazonRDSDataFullAccess"
)

# Importa o cluster ECS
import_resource "aws_ecs_cluster" "tf_ecs_cluster" "${CLUSTER_NAME}"

# Importa o service
import_resource "aws_ecs_service" "tf_ecs_service" "${CLUSTER_NAME}/${SERVICE_NAME}"

# Importa o security group
import_resource "aws_security_group" "tf_ecs_service_sg" "${SECURITY_GROUP_ID}"

# Importa a task definition
import_resource "aws_ecs_task_definition" "tf_ecs_task_definition" "${TASK_DEF_ARN}"

# Importa a role da task
import_resource "aws_iam_role" "tf_ecs_task_role" "${TASK_ROLE_NAME}"

# Importa as políticas da role
for i in "${!TASK_POLICIES[@]}"; do
  import_resource "aws_iam_role_policy_attachment" "tf_ecs_task_policy_$((i+1))" \
  "${TASK_ROLE_NAME}/arn:aws:iam::aws:policy/${TASK_POLICIES[$i]}"
done
