/*
=========================================================
SQL Server - Procedures de Auditoria (ISO 27001)
=========================================================
Objetivo:
Automatizar verificações de segurança e registrar evidências
em tabela de auditoria.

Tabela esperada:
Auditoria_ISO27001

Padrão de saída:
- Categoria
- Item
- Status (OK / NAO / NA)
- Evidencia
- DataAuditoria
=========================================================
*/

---------------------------------------------------------
-- 1. CONTROLE DE ACESSO
---------------------------------------------------------

CREATE OR ALTER PROCEDURE sp_Auditoria_Sysadmin
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Qtd INT;

    SELECT @Qtd = COUNT(*)
    FROM sys.server_principals sp
    JOIN sys.syslogins sl ON sp.sid = sl.sid
    WHERE sl.sysadmin = 1;

    INSERT INTO Auditoria_ISO27001 (Categoria, Item, Status, Evidencia)
    VALUES (
        'Controle de Acesso',
        'Quantidade de logins sysadmin',
        CASE WHEN @Qtd <= 2 THEN 'OK' ELSE 'NAO' END,
        CONCAT('Quantidade encontrada: ', @Qtd)
    );
END;
GO


CREATE OR ALTER PROCEDURE sp_Auditoria_SA
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Status VARCHAR(10);

    SELECT @Status = 
        CASE 
            WHEN is_disabled = 1 THEN 'OK'
            ELSE 'NAO'
        END
    FROM sys.sql_logins
    WHERE name = 'sa';

    INSERT INTO Auditoria_ISO27001 (Categoria, Item, Status, Evidencia)
    VALUES (
        'Controle de Acesso',
        'Login sa desabilitado',
        ISNULL(@Status, 'NA'),
        'Verificação do status do login sa'
    );
END;
GO


---------------------------------------------------------
-- 2. AUTENTICAÇÃO E IDENTIDADE
---------------------------------------------------------

CREATE OR ALTER PROCEDURE sp_Auditoria_PasswordPolicy
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Qtd INT;

    SELECT @Qtd = COUNT(*)
    FROM sys.sql_logins
    WHERE is_policy_checked = 0;

    INSERT INTO Auditoria_ISO27001 (Categoria, Item, Status, Evidencia)
    VALUES (
        'Autenticacao',
        'Logins sem politica de senha',
        CASE WHEN @Qtd = 0 THEN 'OK' ELSE 'NAO' END,
        CONCAT('Quantidade: ', @Qtd)
    );
END;
GO


---------------------------------------------------------
-- 3. CRIPTOGRAFIA
---------------------------------------------------------

CREATE OR ALTER PROCEDURE sp_Auditoria_TDE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Qtd INT;

    SELECT @Qtd = COUNT(*)
    FROM sys.databases
    WHERE is_encrypted = 0
      AND database_id > 4;

    INSERT INTO Auditoria_ISO27001 (Categoria, Item, Status, Evidencia)
    VALUES (
        'Criptografia',
        'Bancos sem TDE',
        CASE WHEN @Qtd = 0 THEN 'OK' ELSE 'NAO' END,
        CONCAT('Bancos sem TDE: ', @Qtd)
    );
END;
GO


---------------------------------------------------------
-- 4. AUDITORIA
---------------------------------------------------------

CREATE OR ALTER PROCEDURE sp_Auditoria_SQLAudit
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Qtd INT;

    SELECT @Qtd = COUNT(*)
    FROM sys.server_audits
    WHERE is_state_enabled = 1;

    INSERT INTO Auditoria_ISO27001 (Categoria, Item, Status, Evidencia)
    VALUES (
        'Auditoria',
        'SQL Server Audit habilitado',
        CASE WHEN @Qtd > 0 THEN 'OK' ELSE 'NAO' END,
        CONCAT('Audits ativos: ', @Qtd)
    );
END;
GO


---------------------------------------------------------
-- 5. BACKUP
---------------------------------------------------------

CREATE OR ALTER PROCEDURE sp_Auditoria_Backup
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Qtd INT;

    SELECT @Qtd = COUNT(*)
    FROM (
        SELECT d.name
        FROM sys.databases d
        LEFT JOIN msdb.dbo.backupset b 
            ON d.name = b.database_name
        WHERE d.database_id > 4
        GROUP BY d.name
        HAVING MAX(b.backup_finish_date) IS NULL
    ) X;

    INSERT INTO Auditoria_ISO27001 (Categoria, Item, Status, Evidencia)
    VALUES (
        'Backup',
        'Bancos sem backup',
        CASE WHEN @Qtd = 0 THEN 'OK' ELSE 'NAO' END,
        CONCAT('Quantidade: ', @Qtd)
    );
END;
GO


---------------------------------------------------------
-- 6. VULNERABILIDADES
---------------------------------------------------------

CREATE OR ALTER PROCEDURE sp_Auditoria_Features
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Qtd INT;

    SELECT @Qtd = COUNT(*)
    FROM sys.configurations
    WHERE name = 'xp_cmdshell'
      AND value_in_use = 1;

    INSERT INTO Auditoria_ISO27001 (Categoria, Item, Status, Evidencia)
    VALUES (
        'Seguranca',
        'xp_cmdshell habilitado',
        CASE WHEN @Qtd = 0 THEN 'OK' ELSE 'NAO' END,
        CONCAT('Habilitado: ', @Qtd)
    );
END;
GO


---------------------------------------------------------
-- PROCEDURE PRINCIPAL
---------------------------------------------------------

CREATE OR ALTER PROCEDURE sp_Auditoria_Geral
AS
BEGIN
    SET NOCOUNT ON;

    -- Limpa execução do dia
    DELETE FROM Auditoria_ISO27001
    WHERE CAST(DataAuditoria AS DATE) = CAST(GETDATE() AS DATE);

    EXEC sp_Auditoria_Sysadmin;
    EXEC sp_Auditoria_SA;
    EXEC sp_Auditoria_PasswordPolicy;
    EXEC sp_Auditoria_TDE;
    EXEC sp_Auditoria_SQLAudit;
    EXEC sp_Auditoria_Backup;
    EXEC sp_Auditoria_Features;
END;
GO


---------------------------------------------------------
-- EXECUÇÃO
---------------------------------------------------------

-- EXEC sp_Auditoria_Geral;
