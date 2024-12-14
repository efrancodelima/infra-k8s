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

  if [ "$task_arn" == "None" ]; then
    echo "None"
    return
  fi
  
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
LB_NAME="lanchonete-load-balancer"

ECS_SG_NAME="lanchonete-ecs-sg"
LB_SG_NAME="lanchonete-lb-sg"
ECS_SG_ID=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=${ECS_SG_NAME}" --query "SecurityGroups[0].GroupId" --output text)
LB_SG_ID=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=${LB_SG_NAME}" --query "SecurityGroups[0].GroupId" --output text)

TASK_DEF_ARN=$(get_task_definition_arn)
TASK_ROLE_NAME="lanchonete-ecs-task-role"
TASK_EXEC_ROLE_NAME="lanchonete-ecs-task-exec-role"

TASK_POLICY_RDS="AmazonRDSFullAccess"
TASK_POLICY_RDS_DATA="AmazonRDSDataFullAccess"
TASK_EXEC_POLICY_TER="service-role/AmazonECSTaskExecutionRolePolicy"
TASK_EXEC_POLICY_CW="CloudWatchFullAccess"


### CLUSTER

# Importa o cluster ECS
import_resource "aws_ecs_cluster" "tf_ecs_cluster" "${CLUSTER_NAME}"


### SERVICE

# Importa o service
import_resource "aws_ecs_service" "tf_ecs_service" "${CLUSTER_NAME}/${SERVICE_NAME}"

# Importa os securities groups
import_resource "aws_security_group" "tf_ecs_service_sg" "${ECS_SG_ID}"


### TASK DEFINITION

# Importa a task definition
import_resource "aws_ecs_task_definition" "tf_ecs_task_definition" "${TASK_DEF_ARN}"

# Importa a task role e a task execution role
import_resource "aws_iam_role" "tf_ecs_task_role" "${TASK_ROLE_NAME}"
import_resource "aws_iam_role" "tf_ecs_task_exec_role" "${TASK_EXEC_ROLE_NAME}"

# Importa as políticas da task role
import_resource "aws_iam_role_policy_attachment" "tf_ecs_task_policy_rds" \
"${TASK_ROLE_NAME}/arn:aws:iam::aws:policy/${TASK_POLICY_RDS}"

import_resource "aws_iam_role_policy_attachment" "tf_ecs_task_policy_rds_data" \
"${TASK_ROLE_NAME}/arn:aws:iam::aws:policy/${TASK_POLICY_RDS_DATA}"

# Importa as políticas da task execution role
import_resource "aws_iam_role_policy_attachment" "tf_ecs_task_exec_policy_ter" \
"${TASK_EXEC_ROLE_NAME}/arn:aws:iam::aws:policy/${TASK_EXEC_POLICY_TER}"

import_resource "aws_iam_role_policy_attachment" "tf_ecs_task_exec_policy_cw" \
"${TASK_EXEC_ROLE_NAME}/arn:aws:iam::aws:policy/${TASK_EXEC_POLICY_CW}"


### LOAD BALANCER

# Importa o load balancer
# import_resource "aws_lb" "tf_load_balancer" "arn:aws:elasticloadbalancing:us-east-1:${AWS_ACCOUNT_ID}:loadbalancer/${LB_NAME}"

# Importa o security group do load balancer
# import_resource "aws_security_group" "tf_lb_sg" "${LB_SG_ID}"