# SQL Server ISO 27001 Audit

Projeto prático de auditoria em SQL Server baseado nos controles da ISO/IEC 27001.

---

## Objetivo

Demonstrar como aplicar conceitos de segurança da informação em ambientes SQL Server, utilizando:

- Checklist baseado na ISO 27001
- Queries de auditoria
- Procedures automatizadas
- Dashboard no Grafana

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
│   └── grafana_dashboard.json (opcional)
│
├── 04-Documentacao
│   └── como_funciona.md
│
└── README.md
```

---

## Como utilizar

### 1. Criar tabela de auditoria

```sql
CREATE TABLE Auditoria_ISO27001
(
    ID INT IDENTITY(1,1),
    Categoria VARCHAR(100),
    Item VARCHAR(255),
    Status VARCHAR(10),
    Evidencia VARCHAR(MAX),
    DataAuditoria DATETIME DEFAULT GETDATE()
);
```
--- 

## 2. Executar as procedures
```sql
EXEC sp_Auditoria_Geral;
```
--- 

## 3. Visualizar resultados
```sql
SELECT * FROM Auditoria_ISO27001;
```

---

## 4. Dashboard

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

Este projeto tem caráter educacional e demonstra uma abordagem prática de auditoria baseada na ISO 27001 aplicada a banco de dados.

