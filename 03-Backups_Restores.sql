use master;
--BACKUP COMPLETO

backup database Northwind
to disk = 'C:\basedatos\backups\backupNorthwind.bak'
with 
name = 'BackupCompleto_03_03_2025',
description = 'Backup completo de la base de datos Northwind'
go

--BACKUP DIFERENCIAL
backup database Northwind
to disk = 'C:\basedatos\backups\backupNorthwind.bak'
with 
name = 'BackupDiferencial_04_03_2025',
description = 'Backup diferencial1 de la base de datos Northwind',
differential
go

--BACKUP DE LOG DE TRANSACCIONES
backup database Northwind
to disk = 'C:\basedatos\backups\backupNorthwind.bak'
with 
name = 'BackupLog1',
description = 'Backup de logs transaccional de la base de datos Northwind'
go

--BACKUP DE SOLO COPIA
backup database Northwind
to disk = 'C:\basedatos\backups\backupNorthwind.bak'
with 
copy_only,
name = 'Backupsolocopia',
description = 'Backup de solo copia de la base de datos Northwind'
go

--BACKUP DE UN FILEGROUP (PARCIALES)
backup database Northwind
filegroup = 'Primary'
to disk = 'C:\basedatos\backups\backupNorthwind.bak'
with 
name = 'Northwind_filegroup_primary'
go

--BACKUP DE LA COLA DE LOG
backup log Northwind
to disk  = 'C:\basedatos\backups\backupNorthwind.bak'
with
recovery,
name = 'Backup_cola_log1',
description = 'Realiza un backup de cola de log'
go