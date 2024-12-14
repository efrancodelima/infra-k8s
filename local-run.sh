#!/bin/bash

# Defina as variáveis de ambiente antes de executar esse script
# $ACCOUNT_ID
# $DATASOURCE_URL
# $DATASOURCE_USERNAME
# $DATASOURCE_PASSWORD

# Iniciar o terraform
# terraform init

# Importar os recursos
./resources-import.sh

# Executar o planejamento
terraform plan \
-var="aws_account_id=${ACCOUNT_ID}" \
-var="db_url=${DATASOURCE_URL}" \
-var="db_username=${DATASOURCE_USERNAME}" \
-var="db_password=${DATASOURCE_PASSWORD}" \
-out=tfplan

# Aplicar o planejamento
terraform apply "tfplan"