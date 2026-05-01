/*
PROPOSITO DEL SCRIPT: 
	Crear la base de datos PT_Desembolsos, y las tablas asociadas a esta. 
ADVERTENCIA:
	- Este Script Borra la base de datos PT_Desembolsos, en caso de que exista.
*/

USE master;
GO

-- Drop and recreate the 'DataWarehouseAnalytics' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'PT_Desembolsos')
BEGIN
    ALTER DATABASE PT_Desembolsos SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE PT_Desembolsos;
END;
GO

CREATE TABLE MAESTRA_PRODUCTOS(
	cod_MP VARCHAR(10),
	nombre VARCHAR(50),
	es_activo BIT
	CONSTRAINT pk_MAESTRA_PRODUCTOS PRIMARY KEY (cod_MP)
);
GO 

CREATE TABLE MAESTRA_CLIENTES(
	cod_MC VARCHAR(10),
	nombre VARCHAR(50),
	tipo_persona VARCHAR(10),
	es_activo BIT
	CONSTRAINT pk_MAESTRA_CLIENTES PRIMARY KEY (cod_MC)
);
GO 

CREATE TABLE UBIGEO(
	cod_ubigeo VARCHAR(10),
	departamento VARCHAR(50),
	zona VARCHAR(10)
	CONSTRAINT pk_UBIGEO PRIMARY KEY (cod_ubigeo)
);
GO 

CREATE TABLE DESEMBOLSOS(
	ID INT,
	periodo INT,
	cod_cliente VARCHAR(10),
	cod_producto VARCHAR(10),
	cod_ubigeo VARCHAR(10),
	monto DECIMAL(10,2)
	CONSTRAINT pk_DESEMBOLSOS PRIMARY KEY (ID),

	CONSTRAINT fk_MC_DESEMBOLSOS FOREIGN KEY (cod_cliente)
		REFERENCES MAESTRA_CLIENTES(cod_MC),
	CONSTRAINT fk_MP_DESEMBOLSOS FOREIGN KEY (cod_producto)
		REFERENCES MAESTRA_PRODUCTOS(cod_MP),
	CONSTRAINT fk_UBIGEO_DESEMBOLSOS FOREIGN KEY (cod_ubigeo)
		REFERENCES UBIGEO(cod_ubigeo)
);
GO 
