# ISO 27001 para SQL Server

## Checklist + Kit de Auditoria

---

## 1. Controle de Acesso

- Existe política de acesso formal definida?
- Usuários possuem apenas o mínimo privilégio necessário?

**Evidência: logins com privilégio sysadmin**
```sql
SELECT 
    sp.name AS LoginName,
    sp.type_desc,
    sl.sysadmin
FROM sys.server_principals sp
JOIN sys.syslogins sl ON sp.sid = sl.sid
WHERE sl.sysadmin = 1;
O login sa está desabilitado ou controlado?
SELECT name, is_disabled
FROM sys.sql_logins
WHERE name = 'sa';
Há revisão periódica de acessos?
Contas inativas são removidas?
2. Autenticação e Identidade
Políticas de senha estão habilitadas?
SELECT name, is_policy_checked, is_expiration_checked
FROM sys.sql_logins
WHERE is_policy_checked = 0;
Logins SQL são evitados ou controlados?
Tentativas de login falhas são monitoradas?
EXEC xp_readerrorlog 0, 1, 'Login failed';
Integração com AD está implementada?
MFA é utilizado quando possível?
3. Criptografia e Proteção de Dados
TDE está habilitado nos bancos críticos?
SELECT 
    db.name,
    db.is_encrypted
FROM sys.databases db;
Backups são criptografados?
Dados sensíveis usam Always Encrypted ou equivalente?
Conexões usam TLS/SSL?
SELECT 
    session_id,
    encrypt_option
FROM sys.dm_exec_connections;
Chaves criptográficas são protegidas?
4. Auditoria e Monitoramento
SQL Server Audit está ativo?
SELECT name, is_state_enabled
FROM sys.server_audits;
Eventos auditados incluem logins, alterações e acesso a dados?
SELECT *
FROM sys.server_audit_specifications;
Logs são enviados para SIEM (ex: Microsoft Sentinel)?
Existe monitoramento em tempo real?
Alertas estão configurados?
5. Gestão de Vulnerabilidades
SQL Server está atualizado?
SELECT @@VERSION;
Vulnerability Assessment é executado?
Features não utilizadas estão desabilitadas?
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;

SELECT name, value_in_use
FROM sys.configurations
WHERE name IN (
    'xp_cmdshell',
    'Ole Automation Procedures',
    'Ad Hoc Distributed Queries'
);
Contas padrão ou testes foram removidas?
Portas e serviços estão restritos?
6. Backup e Recuperação
Política de backup está documentada?
Backups estão sendo realizados?
SELECT 
    database_name,
    MAX(backup_finish_date) AS LastBackup
FROM msdb.dbo.backupset
GROUP BY database_name;
Existem bancos sem backup?
SELECT d.name
FROM sys.databases d
LEFT JOIN msdb.dbo.backupset b 
    ON d.name = b.database_name
GROUP BY d.name
HAVING MAX(b.backup_finish_date) IS NULL;
Testes de restore são realizados?
Backups são armazenados fora do servidor?
Backups têm controle de acesso?
7. Gestão de Mudanças
Existe controle formal de mudanças?
Scripts são versionados (ex: Git)?
Alterações em produção são controladas?
Existe aprovação antes de mudanças críticas?
Mudanças são auditáveis?
8. Classificação de Dados
Dados sensíveis estão identificados?
SELECT *
FROM sys.sensitivity_classifications;
Existe classificação de dados?
Dados sensíveis possuem restrição de acesso?
SELECT 
    dp.name,
    dp.type_desc,
    perm.permission_name,
    perm.state_desc
FROM sys.database_permissions perm
JOIN sys.database_principals dp 
    ON perm.grantee_principal_id = dp.principal_id
WHERE perm.state_desc = 'GRANT';
Dynamic Data Masking está implementado?
Há política de retenção de dados?
9. Segurança de Infraestrutura
Servidor SQL está isolado em rede segura?
Firewall está configurado corretamente?
Acesso remoto é restrito?
Conta de serviço tem privilégios mínimos?
Hardening do SO foi aplicado?
10. Logs e Evidência
Logs são armazenados com retenção definida?
Logs são protegidos contra alteração?
Existe trilha de auditoria completa?
Logs são revisados regularmente?
Evidências são mantidas para auditoria?
11. Alta Disponibilidade e DR
Existe estratégia de HA (Always On / Log Shipping)?
RPO e RTO estão definidos?
Testes de failover são realizados?
Plano de DR está documentado?
Equipe sabe executar o plano?
12. Processos e Governança
Existem runbooks operacionais?
Procedimentos estão documentados?
Equipe foi treinada?
Existe segregação de funções (DBA vs Dev)?
Auditorias internas são realizadas?
