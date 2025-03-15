-- BRIAN EMMANUEL FLORES HERNANDEZ

USE AdminBD;
GO

DROP PROCEDURE IF EXISTS sp_CreateDatabase;
GO

CREATE PROCEDURE sp_CreateDatabase
    @DBName NVARCHAR(128),
    @DataFilePath NVARCHAR(260),
    @LogFilePath NVARCHAR(260),
    @DataFileSizeMB INT = 50,
    @LogFileSizeMB INT = 25,
    @DataFileGrowth NVARCHAR(10) = '25%',
    @LogFileGrowth NVARCHAR(10) = '25%',
    @DataFileMaxSize INT = 400
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si la base de datos ya existe
    IF EXISTS (SELECT 1 FROM sys.databases WHERE name = @DBName)
    BEGIN
        PRINT 'ERROR: La base de datos ya existe.';
        RETURN -20;
    END

    -- Evitar nombres vacíos o nulos
    IF @DBName IS NULL OR LTRIM(RTRIM(@DBName)) = ''
    BEGIN
        PRINT 'ERROR: El nombre de la base de datos no puede estar vacío.';
        RETURN -30;
    END

    -- Validar que las rutas de los archivos no sean nulas o vacías
    IF @DataFilePath IS NULL OR LTRIM(RTRIM(@DataFilePath)) = ''
    BEGIN
        PRINT 'ERROR: La ruta del archivo MDF es obligatoria.';
        RETURN -40;
    END

    IF @LogFilePath IS NULL OR LTRIM(RTRIM(@LogFilePath)) = ''
    BEGIN
        PRINT 'ERROR: La ruta del archivo LDF es obligatoria.';
        RETURN -41;
    END

    -- Validar tamaños de archivos (Evitar valores negativos o absurdos)
    IF @DataFileSizeMB <= 0
    BEGIN
        PRINT 'ERROR: El tamaño del archivo MDF debe ser mayor a 0 MB.';
        RETURN -50;
    END

    IF @LogFileSizeMB <= 0
    BEGIN
        PRINT 'ERROR: El tamaño del archivo LDF debe ser mayor a 0 MB.';
        RETURN -51;
    END

    -- Validar que los valores de crecimiento sean correctos (no negativos)
    IF TRY_CAST(REPLACE(@DataFileGrowth, '%', '') AS INT) IS NULL OR TRY_CAST(REPLACE(@DataFileGrowth, '%', '') AS INT) < 1
    BEGIN
        PRINT 'ERROR: El crecimiento del archivo MDF debe ser un porcentaje mayor a 0%.';
        RETURN -60;
    END

    IF TRY_CAST(REPLACE(@LogFileGrowth, '%', '') AS INT) IS NULL OR TRY_CAST(REPLACE(@LogFileGrowth, '%', '') AS INT) < 1
    BEGIN
        PRINT 'ERROR: El crecimiento del archivo LDF debe ser un porcentaje mayor a 0%.';
        RETURN -61;
    END

    -- Construcción dinámica del comando SQL para crear la base de datos
    DECLARE @SQL NVARCHAR(MAX);

    SET @SQL = '
    CREATE DATABASE ' + QUOTENAME(@DBName) + '
    ON PRIMARY
    (
        NAME = ' + QUOTENAME(@DBName + '_Data') + ',
        FILENAME = ''' + @DataFilePath + ''',
        SIZE = ' + CAST(@DataFileSizeMB AS NVARCHAR(10)) + 'MB,
        FILEGROWTH = ' + @DataFileGrowth + 
        CASE WHEN @DataFileMaxSize IS NOT NULL THEN ', MAXSIZE = ' + CAST(@DataFileMaxSize AS NVARCHAR(10)) + 'MB' ELSE '' END + '
    )
    LOG ON
    (
        NAME = ' + QUOTENAME(@DBName + '_Log') + ',
        FILENAME = ''' + @LogFilePath + ''',
        SIZE = ' + CAST(@LogFileSizeMB AS NVARCHAR(10)) + 'MB,
        FILEGROWTH = ' + @LogFileGrowth + '
    );';

    BEGIN TRY
        EXEC sp_executesql @SQL;
        PRINT 'Base de datos creada exitosamente.';
        RETURN 0;  -- Devuelve 0 si tuvo éxito
    END TRY
    BEGIN CATCH
        PRINT 'ERROR: ' + ERROR_MESSAGE();
        RETURN -2;  -- Devuelve -2 si hubo un error
    END CATCH
END;
GO



--VERIFICAMOS QUE SE HAYA CREADO EL STORED CORRECTAMENTE
EXEC sp_helptext sp_CreateDatabase;


-- COMANDO PARA EJECUTAR UN EJEMPLO
EXEC sp_CreateDatabase
    @DBName = 'Pruebaaa',
    @DataFilePath = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Pruebita7.mdf',
    @LogFilePath = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Pruebita7.ldf',
    @DataFileSizeMB = null,
    @LogFileSizeMB = -100,
    @DataFileGrowth = '20%',
    @LogFileGrowth = '20%',
    @DataFileMaxSize = 500;


--COMANDO PARA BORRAR STORED
DROP PROCEDURE IF EXISTS sp_CreateDatabase;
