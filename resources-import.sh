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
    --output text  2>/dev/null)

  if [ "$task_arn" == "None" ]; then
    echo "None"
    return
  fi
  
  local task_def_arn=$(aws ecs describe-tasks \
    --cluster "lanchonete-ecs-cluster" \
    --tasks "$task_arn" \
    --query 'tasks[0].taskDefinitionArn' \
    --output text 2>/dev/null)
  
  echo "$task_def_arn"
}

# Constantes
SG_NAME_ECS="lanchonete-ecs-sg"
SG_NAME_LB="lanchonete-lb-sg"

SG_ID_ECS=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=${SG_NAME_ECS}" --query "SecurityGroups[0].GroupId" --output text 2>/dev/null)
SG_ID_LB=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=${SG_NAME_LB}" --query "SecurityGroups[0].GroupId" --output text 2>/dev/null)

TASK_ROLE_NAME="lanchonete-ecs-task-role"
TASK_EXEC_ROLE_NAME="lanchonete-ecs-task-exec-role"

POLICY_RDS_TASK="AmazonRDSFullAccess"
POLICY_RDS_DATA_TASK="AmazonRDSDataFullAccess"
POLICY_TER_TASK_EXEC="service-role/AmazonECSTaskExecutionRolePolicy"
POLICY_CW_TASK_EXEC="CloudWatchFullAccess"

CLUSTER_NAME="lanchonete-ecs-cluster"
TASK_DEF_ARN=$(get_task_definition_arn)
SERVICE_NAME="lanchonete-ecs-service"

TG_NAME="lanchonete-target-group"
TG_ARN=$(aws elbv2 describe-target-groups --names "${TG_NAME}" --query 'TargetGroups[0].TargetGroupArn' --output text 2>/dev/null)

LB_NAME="lanchonete-load-balancer"
LB_ARN=$(aws elbv2 describe-load-balancers --names ${LB_NAME} --query 'LoadBalancers[0].LoadBalancerArn' --output text 2>/dev/null)

LISTENER_ARN=$(aws elbv2 describe-listeners --load-balancer-arn ${LB_ARN} --query 'Listeners[0].ListenerArn' --output text 2>/dev/null)


# Importa os securities groups
if [ "${SG_ID_ECS}" = "None" ]; then
    echo "Security group do service ECS não encontrado."
else
    import_resource "aws_security_group" "tf_ecs_sg" "${SG_ID_ECS}"
fi

if [ "${SG_ID_LB}" = "None" ]; then
    echo "Security group do load balancer não encontrado."
else
    import_resource "aws_security_group" "tf_lb_sg" "${SG_ID_LB}"
fi

# Importa as roles
import_resource "aws_iam_role" "tf_ecs_task_role" "${TASK_ROLE_NAME}"
import_resource "aws_iam_role" "tf_ecs_task_exec_role" "${TASK_EXEC_ROLE_NAME}"

# Importa as policies
import_resource "aws_iam_role_policy_attachment" "tf_ecs_task_policy_rds" \
"${TASK_ROLE_NAME}/arn:aws:iam::aws:policy/${POLICY_RDS_TASK}"

import_resource "aws_iam_role_policy_attachment" "tf_ecs_task_policy_rds_data" \
"${TASK_ROLE_NAME}/arn:aws:iam::aws:policy/${POLICY_RDS_DATA_TASK}"

import_resource "aws_iam_role_policy_attachment" "tf_ecs_task_exec_policy_ter" \
"${TASK_EXEC_ROLE_NAME}/arn:aws:iam::aws:policy/${POLICY_TER_TASK_EXEC}"

import_resource "aws_iam_role_policy_attachment" "tf_ecs_task_exec_policy_cw" \
"${TASK_EXEC_ROLE_NAME}/arn:aws:iam::aws:policy/${POLICY_CW_TASK_EXEC}"

# Importa o cluster
import_resource "aws_ecs_cluster" "tf_ecs_cluster" "${CLUSTER_NAME}"

# Importa a task definition
if [ "${TASK_DEF_ARN}" = "None" ]; then
    echo "Task definition não encontrada."
else
    import_resource "aws_ecs_task_definition" "tf_ecs_task_definition" "${TASK_DEF_ARN}"
fi

# Importa o service
import_resource "aws_ecs_service" "tf_ecs_service" "${CLUSTER_NAME}/${SERVICE_NAME}"

# Importa o target group
if [ -z "${TG_ARN}" ]; then
    echo "Target group não encontrado."
else
    import_resource "aws_lb_target_group" "tf_lb_tg" ${TG_ARN}
fi

# Importa o load balancer
if [ -z "${LB_ARN}" ]; then
    echo "Load balancer não encontrado."
else
    import_resource "aws_lb" "tf_load_balancer" "${LB_ARN}"
fi

# Importa o listener
if [ -z "${LISTENER_ARN}" ]; then
    echo "Listener não encontrado."
else
    import_resource "aws_lb_listener" "tf_lb_listener" ${LISTENER_ARN}
fi
