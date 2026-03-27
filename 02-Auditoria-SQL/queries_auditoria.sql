/*
=========================================================
SQL Server - Queries de Auditoria (ISO 27001)
=========================================================
Objetivo:
Conjunto de consultas para validação de controles de segurança
em ambientes SQL Server.

Uso:
Executar conforme necessidade para análise manual ou validação
pontual dos controles.

Observação:
Estas queries não alteram dados (somente leitura).
=========================================================
*/

---------------------------------------------------------
-- 1. CONTROLE DE ACESSO
---------------------------------------------------------

-- Logins com privilégio de sysadmin
SELECT 
    sp.name AS LoginName,
    sp.type_desc,
    sl.sysadmin
FROM sys.server_principals sp
JOIN sys.syslogins sl ON sp.sid = sl.sid
WHERE sl.sysadmin = 1;

-- Status do login 'sa'
SELECT 
    name,
    is_disabled
FROM sys.sql_logins
WHERE name = 'sa';


---------------------------------------------------------
-- 2. AUTENTICAÇÃO E IDENTIDADE
---------------------------------------------------------

-- Logins sem política de senha
SELECT 
    name,
    is_policy_checked,
    is_expiration_checked
FROM sys.sql_logins
WHERE is_policy_checked = 0;

-- Falhas de login registradas
EXEC xp_readerrorlog 0, 1, 'Login failed';


---------------------------------------------------------
-- 3. CRIPTOGRAFIA E PROTEÇÃO DE DADOS
---------------------------------------------------------

-- Bancos com/sem TDE
SELECT 
    name,
    is_encrypted
FROM sys.databases;

-- Conexões com/sem criptografia
SELECT 
    session_id,
    encrypt_option
FROM sys.dm_exec_connections;


---------------------------------------------------------
-- 4. AUDITORIA E MONITORAMENTO
---------------------------------------------------------

-- Auditoria habilitada
SELECT 
    name,
    is_state_enabled
FROM sys.server_audits;

-- Especificações de auditoria
SELECT *
FROM sys.server_audit_specifications;


---------------------------------------------------------
-- 5. GESTÃO DE VULNERABILIDADES
---------------------------------------------------------

-- Versão do SQL Server
SELECT @@VERSION;

-- Features potencialmente perigosas
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;

SELECT 
    name,
    value_in_use
FROM sys.configurations
WHERE name IN (
    'xp_cmdshell',
    'Ole Automation Procedures',
    'Ad Hoc Distributed Queries'
);


---------------------------------------------------------
-- 6. BACKUP E RECUPERAÇÃO
---------------------------------------------------------

-- Último backup por banco
SELECT 
    database_name,
    MAX(backup_finish_date) AS LastBackup
FROM msdb.dbo.backupset
GROUP BY database_name;

-- Bancos sem backup
SELECT 
    d.name
FROM sys.databases d
LEFT JOIN msdb.dbo.backupset b 
    ON d.name = b.database_name
GROUP BY d.name
HAVING MAX(b.backup_finish_date) IS NULL;


---------------------------------------------------------
-- 7. CLASSIFICAÇÃO DE DADOS
---------------------------------------------------------

-- Classificação de dados (se configurada)
SELECT *
FROM sys.sensitivity_classifications;

-- Permissões concedidas
SELECT 
    dp.name,
    dp.type_desc,
    perm.permission_name,
    perm.state_desc
FROM sys.database_permissions perm
JOIN sys.database_principals dp 
    ON perm.grantee_principal_id = dp.principal_id
WHERE perm.state_desc = 'GRANT';


---------------------------------------------------------
-- FIM
---------------------------------------------------------
