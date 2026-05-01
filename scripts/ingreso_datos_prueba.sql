/*
PROPOSITO DEL SCRIPT:
	Llenar las tablas con algunos datos de prueba
*/

USE PT_Desembolsos;
GO

INSERT INTO MAESTRA_PRODUCTOS(cod_MP,nombre,es_activo)
VALUES 	('P00A', 'PRODUCTO A', 1),
		('P00B', 'PRODUCTO B', 1),
		('P00C', 'PRODUCTO C', 0),
		('P01H', 'PRODUCTO H', 1);
GO

INSERT INTO MAESTRA_CLIENTES(cod_MC,nombre,tipo_persona,es_activo) 
VALUES ('0001','Cliente 1', 'PJ',1),
	   ('0002','Cliente 2', 'PN',1),
	   ('0003','Cliente 3', 'PN',0),
	   ('0004','Cliente 4', 'PJ',1);
GO

INSERT INTO UBIGEO(cod_ubigeo,departamento,zona) 
VALUES ('A01','LIMA', 'LIMA'),
	   ('A02','LA LIBERTAD', 'NORTE'),
	   ('A03','AREQUIPA', 'SUR'),
	   ('A04','IQUITOS', 'ORIENTE');
GO

INSERT INTO DESEMBOLSOS(ID,periodo,cod_cliente,cod_producto,cod_ubigeo,monto) 
VALUES (1,202303, '0001','P00A','A01',5000),
	   (2,202202, '0001','P00B','A03',3500),
	   (3,202403, '0001','P00C','A02',6000),
	   (4,202203, '0001','P00B','A04',5000),
	   (5,202303, '0002','P00C','A01',3000),
	   (6,202202, '0002','P01H','A04',2000),
	   (7,202203, '0002','P00A','A03',2500);
GO
