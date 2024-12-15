#!/bin/bash

echo "Importação de recusos iniciada."

# Função para importar os recursos passando os parâmetros necessários
import_resource() {
  local resource_type=$1
  local resource_name=$2
  local resource_id=$3

  echo " "

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

# Importa os securities groups
SG_NAME_ECS="lanchonete-ecs-sg"
SG_NAME_LB="lanchonete-lb-sg"

SG_ID_ECS=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=${SG_NAME_ECS}" --query "SecurityGroups[0].GroupId" --output text 2>/dev/null)
SG_ID_LB=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=${SG_NAME_LB}" --query "SecurityGroups[0].GroupId" --output text 2>/dev/null)

if [ "${SG_ID_ECS}" = "None" ]; then
    echo " "
    echo "Security group do service ECS não encontrado."
else
    import_resource "aws_security_group" "tf_ecs_sg" "${SG_ID_ECS}"
fi

if [ "${SG_ID_LB}" = "None" ]; then
    echo " "
    echo "Security group do load balancer não encontrado."
else
    import_resource "aws_security_group" "tf_lb_sg" "${SG_ID_LB}"
fi

# Importa as roles
TASK_ROLE_NAME="lanchonete-ecs-task-role"
TASK_EXEC_ROLE_NAME="lanchonete-ecs-task-exec-role"

import_resource "aws_iam_role" "tf_ecs_task_role" "${TASK_ROLE_NAME}"
import_resource "aws_iam_role" "tf_ecs_task_exec_role" "${TASK_EXEC_ROLE_NAME}"

# Importa as policies
POLICY_RDS_TASK="AmazonRDSFullAccess"
POLICY_RDS_DATA_TASK="AmazonRDSDataFullAccess"

POLICY_TER_TASK_EXEC="service-role/AmazonECSTaskExecutionRolePolicy"
POLICY_CW_TASK_EXEC="CloudWatchFullAccess"

import_resource "aws_iam_role_policy_attachment" "tf_ecs_task_policy_rds" \
"${TASK_ROLE_NAME}/arn:aws:iam::aws:policy/${POLICY_RDS_TASK}"

import_resource "aws_iam_role_policy_attachment" "tf_ecs_task_policy_rds_data" \
"${TASK_ROLE_NAME}/arn:aws:iam::aws:policy/${POLICY_RDS_DATA_TASK}"

import_resource "aws_iam_role_policy_attachment" "tf_ecs_task_exec_policy_ter" \
"${TASK_EXEC_ROLE_NAME}/arn:aws:iam::aws:policy/${POLICY_TER_TASK_EXEC}"

import_resource "aws_iam_role_policy_attachment" "tf_ecs_task_exec_policy_cw" \
"${TASK_EXEC_ROLE_NAME}/arn:aws:iam::aws:policy/${POLICY_CW_TASK_EXEC}"

# Importa o cluster
CLUSTER_NAME="lanchonete-ecs-cluster"
import_resource "aws_ecs_cluster" "tf_ecs_cluster" "${CLUSTER_NAME}"

# Importa a task definition
TASK_DEF_ARN=$(get_task_definition_arn)

if [ "${TASK_DEF_ARN}" = "None" ]; then
    echo " "
    echo "Task definition não encontrada."
else
    import_resource "aws_ecs_task_definition" "tf_ecs_task_definition" "${TASK_DEF_ARN}"
fi

# Importa o service
SERVICE_NAME="lanchonete-ecs-service"
import_resource "aws_ecs_service" "tf_ecs_service" "${CLUSTER_NAME}/${SERVICE_NAME}"

# Importa o target group
TG_NAME="lanchonete-target-group"
TG_ARN=$(aws elbv2 describe-target-groups --names "${TG_NAME}" --query 'TargetGroups[0].TargetGroupArn' --output text 2>/dev/null)

if [ -z "${TG_ARN}" ]; then
    echo " "
    echo "Target group não encontrado."
else
    import_resource "aws_lb_target_group" "tf_lb_tg" ${TG_ARN}
fi

# Importa o load balancer
LB_NAME="lanchonete-load-balancer"
LB_ARN=$(aws elbv2 describe-load-balancers --names ${LB_NAME} --query 'LoadBalancers[0].LoadBalancerArn' --output text 2>/dev/null)

if [ -z "${LB_ARN}" ]; then
    echo " "
    echo "Load balancer não encontrado."
else
    import_resource "aws_lb" "tf_load_balancer" "${LB_ARN}"
fi

# Importa o listener
LISTENER_ARN=$(aws elbv2 describe-listeners --load-balancer-arn ${LB_ARN} --query 'Listeners[0].ListenerArn' --output text 2>/dev/null)

if [ -z "${LISTENER_ARN}" ]; then
    echo " "
    echo "Listener não encontrado."
else
    import_resource "aws_lb_listener" "tf_lb_listener" ${LISTENER_ARN}
fi

# Importa o API gateway
API_GATEWAY_NAME="lanchonete-api-gateway"
API_GATEWAY_ID=$(aws apigatewayv2 get-apis --query "Items[?Name == '${API_GATEWAY_NAME}'] | [0].ApiId" --output text)

if [ "${API_GATEWAY_ID}" = "None" ]; then
    echo " "
    echo "API Gateway não encontrado."
else
    import_resource "aws_apigatewayv2_api" "tf_api_gateway" ${API_GATEWAY_ID}
fi

# Importa o stage do API gateway
STAGE_NAME="\$default"

if [ "${API_GATEWAY_ID}" = "None" ]; then
    echo " "
    echo "Stage do API Gateway não encontrado."
else
    import_resource "aws_apigatewayv2_stage" "tf_api_stage" ${API_GATEWAY_ID}/${STAGE_NAME}
fi

# Importa a route do API gateway
ROUTE_ID=$(aws apigatewayv2 get-routes --api-id ${API_GATEWAY_ID} --query "Items[0].RouteId" --output text)

if [ "${API_GATEWAY_ID}" = "None" ] || [ "${ROUTE_ID}" = "None" ]; then
    echo " "
    echo "Route do API Gateway não encontrado."
else
    import_resource "aws_apigatewayv2_route" "tf_api_route" ${API_GATEWAY_ID}/${ROUTE_ID}
fi

# Importa a integration do API gateway
INTEGRATION_ID=$(aws apigatewayv2 get-integrations --api-id ${API_GATEWAY_ID} --query "Items[0].IntegrationId" --output text)

if [ "${API_GATEWAY_ID}" = "None" ] || [ "${INTEGRATION_ID}" = "None" ]; then
    echo " "
    echo "Integration do API Gateway não encontrado."
else
    import_resource "aws_apigatewayv2_integration" "tf_api_integration" ${API_GATEWAY_ID}/${INTEGRATION_ID}
fi

# Importa a VPC link
VPC_LINK_NAME="lanchonete-vpc-link"
VPC_LINK_ID=$(aws apigatewayv2 get-vpc-links --query "Items[?Name == '${VPC_LINK_NAME}'] | [0].VpcLinkId" --output text)

if [ "${VPC_LINK_ID}" = "None" ]; then
    echo " "
    echo "VPC Link não encontrado."
else
    import_resource "aws_apigatewayv2_vpc_link" "tf_vpc_link" ${VPC_LINK_ID}
fi

echo "Importação de recursos finalizada!"
echo " "