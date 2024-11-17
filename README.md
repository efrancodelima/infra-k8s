# Tech Challenge - Fase 3

Projeto realizado como atividade avaliativa do curso de **Software Architecture - Pós-Tech - FIAP**.

Link do projeto no GitHub:

- Aplicação: https://github.com/efrancodelima/application
- Infra kubernetes: https://github.com/efrancodelima/infra-k8s
- Infra do banco de dados: https://github.com/efrancodelima/infra-bd
- Function AWS Lambda: https://github.com/efrancodelima/lambda

# Índice

- [Objetivos](#objetivos)
- [Requisitos do negócio](#requisitos-do-negócio)
- [Instruções para executar a aplicação](#instruções-para-executar-a-aplicação)

## Objetivos

Desenvolver um sistema para uma lanchonete, seguindo os pré-requisitos especificados no Tech Challenge.

## Requisitos do negócio

Em relação à fase anterior, foi feita a migração do projeto que antes rodava localmente (com o minikube) para a nuvem da Amazon Web Services (AWS).

O projeto foi dividido em 4 partes:

- uma função lambda para a autenticação do usuário
- uma aplicação com as regras de negócio
- a infraestrutura kubernetes para a aplicação
- a infraestrutura para o banco de dados

Cada parte tem um repositório separado no GitHub, conforme mencionado no início deste documento, e todos os repositórios necessitam pull request para realizar qualquer tipo de alteração na branch main.

A branch main dispara um GitHub Action, que executa o deploy na AWS, criando ou atualizando os recursos. No caso da aplicação, ele também faz o build do arquivo jar, testa o código, faz o build da imagem docker, envia a imagem para o repositório ECR da Amazon (utilizando duas tags: a versão do projeto e a tag latest) e faz o deploy no cluster EKS.

### Função Lambda

Responsável pela autenticação do usuário, que deve se identificar pelo CPF.

Para tal, foi utilizado o API Gateway, o Lambda e o Cognito.

O Lambda também se comunica com o banco de dados para verificar se o CPF já está cadastrado.

### Aplicação

No que diz respeito ao software, o projeto foi desenvolvido em Java (JDK 17) seguindo os princípios da Clean Architecture.

A única alteração no código em relação à fasse anterior é que, como o banco de dados migrou do MySQL para o Amazon Aurora, alguns ajustes foram necessários na configuração do Springboot e nos repositórios.

#### API da aplicação

Não houve mudanças em relação à fase anterior.

Cliente

- Cadastrar cliente
- Buscar cliente pelo CPF

Produto:

- Criar, editar e remover produtos
- Buscar produtos por categoria

Pedido

- Fazer checkout
- Deverá retornar a identificação do pedido
- Atualizar o status do pedido
- Consultar o status do pagamento
- Listar pedidos nessa ordem: Pronto > Em Preparação > Recebido
- Pedidos mais antigos primeiro e mais novos depois.
- Pedidos finalizados não devem aparecer na lista.

### Infraestrutura kubernetes

Foi criado um EKS Cluster para rodar a aplicação. Dentro desse cluster temos o deployment, o service e o HPA.

### Infraestrutura do banco de dados

O banco de dados escolhido foi o Amazon Aurora, que é do tipo relacional e compatível com MySQL e postgreSQL.

Esse banco utiliza o Amazon RDS como service e roda dentro do Aurora Cluster (um cluster específico para banco de dados da AWS).

## Documentação e modelagem do banco de dados

Em construção.

## Instruções para executar a aplicação

Sugestão de ordem para execução das APIs:

- Cadastrar cliente
- Buscar cliente pelo CPF
- Cadastrar produtos
- Editar produto
- Buscar produtos por categoria
- Remover produtos (não remova todos, deixe pelo menos 1)
- Fazer checkout
- Consultar o status do pagamento
- Mock da notificação do Mercado Pago \*
- Atualizar o status do pedido
- Listar pedidos

O status do pedido muda em uma ordem definida: recebido, em preparação, pronto, finalizado. Mas ele não avança se o pedido não tiver o pagamento aprovado, então é necessário realizar o mock da notificação do Mercado Pago antes de atualizar o status do pedido.

Exemplo de mock para a notificação do Mercado Pago usando o curl (você pode usar o Postman também, se preferir).

```
curl -X PUT <URL>/api/v2/pedidos/webhook/ \
-H "Content-Type: application/json" \
-d '{
"id": 1,
"date_created": "2024-09-30T11:26:38.000Z",
"date_approved": "2024-09-30T11:26:38.000Z",
"date_last_updated": "2024-09-30T11:26:38.000Z",
"money_release_date": "2017-09-30T11:22:14.000Z",
"payment_method_id": "Pix",
"payment_type_id": "credit_card",
"status": "approved",
"status_detail": "accredited",
"currency_id": "BRL",
"description": "Pago Pizza",
"collector_id": 2,
"payer": {
  "id": 123,
  "email": "test_user_80507629@testuser.com",
  "identification": {
	"type": "CPF",
	"number": 19119119100
  },
  "type": "customer"
},
"metadata": {},
"additional_info": {},
"external_reference": "MP0001",
"transaction_amount": 250,
"transaction_amount_refunded": 50,
"coupon_amount": 15,
"transaction_details": {
  "net_received_amount": 250,
  "total_paid_amount": 250,
  "overpaid_amount": 0,
  "installment_amount": 250
},
"installments": 1,
"card": {}
}'
```
