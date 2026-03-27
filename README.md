# SQL Server ISO 27001 Audit

Projeto prático de auditoria em SQL Server baseado nos controles da ISO/IEC 27001.

---

## Objetivo

Demonstrar como aplicar conceitos de segurança da informação em ambientes SQL Server, utilizando:

- [Checklist baseado na ISO 27001](01-Checklist/checklist_iso27001_sqlserver.md)
- [Queries de auditoria](02-Auditoria-SQL/queries_auditoria.sql)
- [Procedures automatizadas](02-Auditoria-SQL/procedures_auditoria.sql)
- [Dashboard no Grafana](03-Dashboard/grafana_dashboard.json)

---

## O que este projeto cobre

- Controle de acesso (logins, privilégios, uso do sa)
- Autenticação e políticas de senha
- Criptografia (TDE e conexões seguras)
- Auditoria e monitoramento
- Gestão de vulnerabilidades
- Backup e recuperação
- Classificação de dados
- Hardening básico do ambiente

---
## Estrutura do Projeto

```
sqlserver-iso27001-audit
│
├── 01-Checklist
│   └── checklist_iso27001_sqlserver.md
│
├── 02-Auditoria-SQL
│   ├── queries_auditoria.sql
│   └── procedures_auditoria.sql
│
├── 03-Dashboard
│   └── grafana_dashboard.json
│
└── README.md
```

---

## Como utilizar

1. Executar os scripts disponíveis em `[02-Auditoria-SQL](02-Auditoria-SQL)` para criação das procedures de auditoria

2. Utilizar a procedure principal para execução das verificações

3. Consultar os resultados na tabela de auditoria

4. Conectar a base ao Grafana ou Power BI para visualização dos indicadores

---

## Dashboard

Os dados podem ser consumidos por ferramentas como:

- Grafana
- Power BI

Permite visualizar:

- Percentual de conformidade
- Itens não conformes
- Score por categoria

##

**Resultado**

O projeto gera:

- Base estruturada de auditoria
- Evidência técnica para validação de controles
- Indicadores de conformidade
- Identificação de riscos no ambiente SQL Server

##

**Tecnologias utilizadas**

- SQL Server
- T-SQL
- Grafana

##

**Observações**

Este projeto não tem como objetivo implementar a ISO 27001 completa, mas sim demonstrar como controles de segurança podem ser aplicados de forma prática em ambientes SQL Server.

A solução utiliza queries e procedures para simular um processo de auditoria técnica, gerando evidências que podem ser utilizadas em análises de conformidade.

