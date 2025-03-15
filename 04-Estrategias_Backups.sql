--ESTRATEGIAS DE BACKUPS 
--1. BACKUPS COMPLETOS (FULL)
--2. COMPLETOS + DIFERENCIALES
--3. COMPLETOS + DIFERENCIALES + LOGS DE TRANSACCIONES

/*PLAN DE ESTRATEGIAS DE BACKUPS
backup completo 
*/
backup database Northwind
to disk  = 'C:\basedatos\backups\backupNorthwind.bak'
with 
name = 'Backup_completo_03-03-2025',
description = 'Primer backup completo'
go

use Northwind;
insert into Customers(CustomerID, CompanyName, Country)
values('ABCD3', 'PECSI', 'USA'),
		('ABCD4', 'COCA', 'COLOMBIA')

		select * from Customers where CustomerID = 'ABCD3'

--BACKUP DE LOG
backup log Northwind
to disk  = 'C:\basedatos\backups\backupNorthwind.bak'
with 
name = 'backupLog1',
description = 'Log de 03/03/2025'

insert into Customers(CustomerID, CompanyName, Country)
values('ABCD5', 'papas', 'canada'),
		('ABCD6', 'chetos', 'mexico')




--REVISAR EL ARCHIVO .BAK 
restore headeronly 
from disk = 'C:\basedatos\backups\backupNorthwind.bak'

--BACKUP DIFERENCIAL 
backup database Northwind
to disk  = 'C:\basedatos\backups\backupNorthwind.bak'
with 
name = 'BackupDiferencial1',
description = 'Backup diferencial 03-03-2025',
differential
go

use Northwind;

--ELIMINAMOS
delete Customers
where CustomerID in ('ABCD5', 'ABCD6')

insert into Customers(CustomerID, CompanyName, Country)
values('ABCD8', 'cemex', 'nigeria'),
		('ABCD9', 'goodyear', 'usa')

select * from Customers where CustomerID in ('ABCD8', 'ABCD9');

--backup de log
backup log Northwind
to disk  = 'C:\basedatos\backups\backupNorthwind.bak'
with name = 'BackupLog2',
description = 'Backlog2 04/03/2025'


--ELIMINAR LA BASE DE DATOS NORTHWIND
USE master
go

drop database Northwind

--RESTAURAR EL BACKUP COMPLETO Y DE LOGS

restore database northwind 
from disk = 'C:\basedatos\backups\backupNorthwind.bak'
with file = 1, norecovery

use northwind;

select * from Customers;

--lo volvemos a hacer pero con norevorey
RESTORE DATABASE northwind 
FROM DISK = 'C:\basedatos\backups\backupNorthwind.bak'
WITH FILE = 3, NORECOVERY;

RESTORE LOG northwind 
FROM DISK = 'C:\basedatos\backups\backupNorthwind.bak'
WITH FILE = 2, NORECOVERY;



restore database northwind 
from disk = 'C:\basedatos\backups\backupNorthwind.bak'
with file = 3, recovery

restore log northwind 
from disk= 'C:\basedatos\backups\backupNorthwind.bak'
with file = 4, recovery

use northwind
select * from customers;

RESTORE HEADERONLY 
FROM DISK = 'C:\basedatos\backups\backupNorthwind.bak';




RESTORE DATABASE northwind 
FROM DISK = 'C:\basedatos\backups\backupNorthwind.bak'
WITH FILE = 2, NORECOVERY;


RESTORE LOG northwind 
FROM DISK = 'C:\basedatos\backups\backupNorthwind.bak'
WITH FILE = 3, NORECOVERY;

RESTORE LOG NORTHWND 
FROM DISK = 'C:\basedatos\backups\backupNorthwind.bak'
WITH FILE = 9, RECOVERY;

--restaurar completo y diferencial
RESTORE DATABASE northwind 
FROM DISK = 'C:\basedatos\backups\backupNorthwind.bak'
WITH FILE = 1, NORECOVERY;

restore database northwind from disk= 'C:\basedatos\backups\backupNorthwind.bak'
with file = 3, recovery

use northwind;
select * from customers;