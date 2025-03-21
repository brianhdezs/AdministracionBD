create database paquitabd
on primary
(
	Name = paquitadbData, filename ='C:\basedatos\datanueva\paquitabd.mdf',
	size = 50MB,
	filegrowth=25%,
	maxsize=400MB
)
log on
(
	Name=paquitabdLog, filename ='C:\basedatos\logdata\paquitabd_log.ldf',
	size = 25MB,
	filegrowth=25%
)

--CREAR UN ARCHIVO ADICIONAL
alter database paquitabd
ADD FILE
(
	name='PaquitaDataNDF',
	filename='C:\basedatos\datanueva\paquitabd2.ndf',
	size= 25MB,
	MAXSIZE=500MB,
	filegrowth=10MB
) to filegroup[PRIMARY];

--CREACION DE UN FILEGROUP ADICIONAL
alter database paquitabd
add filegroup SECUNDARIO
GO

--CREACION DE UN ARCHIVO ASOCIADO AL FILEGROUP
alter database paquitabd
add file (
	name='paquitabd_parte1',
	filename='C:\basedatos\datanueva\paquitabd_SECUNDARIO.ndf'
)to filegroup SECUNDARIO

USE paquitabd
--CREAR UNA TABLA EN EL GRUPO DE ARCHIVOS SECUNDARIO 
create table ratadedospatas(
	id int not null identity(1,1),
	nombre nvarchar(100) not null,
	constraint pk_ratadedospatas
	primary key(id),
	constraint unico_nombre
	unique(nombre)
)ON SECUNDARIO

--MODIFICAR EL GRUPO PRIMARIO
create table bichorastrero(
	id int not null identity(1,1),
	nombre nvarchar(100) not null,
	constraint pk_bichorastrero
	primary key(id),
	constraint unico_nombre2
	unique(nombre)
)

use master;
alter database paquitabd
modify filegroup [SECUNDARIO] DEFAULT

USE paquitabd;

create table comparadocontigo(
	id int not null identity(1,1),
	nombredelanimal nvarchar(100) not null,
	defectos varchar(max) not null,
	constraint pk_comparadocontigo
	primary key(id),
	constraint unico_nombre3
	unique(nombredelanimal)
)

--REVISION DEL ESTADO DE LA OPCION DE AJUSTE AUTOMATICO DEL TAMA�O DE ARCHIVOS 

select DATABASEPROPERTYEX('paquitabd', 'ISAUTOSHRINK')


--CAMBIA LA OPCION DE AUTOSHRINK A TRUE
alter database paquitabd
set AUTO_SHRINK ON WITH NO_WAIT
go

--REVISION DEL ESTADO DE LA OPCION DE LA CREACION DE ESTADISTICAS
SELECT DATABASEPROPERTYEX('paquitabd', 'IsAutoCreateStatistics')

alter database paquitabd 
set auto_create_statistics on  --off
go

--CONSULTAR INFORMACION DE LA BASE DE DATOS
use master
go
SP_helpdb paquitabd

--CONSULTAR LA INFORMACI�N DE GRUPOS
use paquitabd
go
SP_helpfilegroup SECUNDARIO