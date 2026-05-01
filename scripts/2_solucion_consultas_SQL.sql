/*
PROPOSITO DEL SCRIPT:
	Resolver las 4 consultas planteadas en el archivo Evaluacion_SQL.pdf

*/

USE PT_Desembolsos;
GO

/* 1.Calcular los desembolsos totales y promedios de productos activos durante el año 2023 
ordenar por el monto total de mayor a menor.*/
SELECT 
	mp.nombre AS PRODUCTO,
	SUM(d.monto) AS MONTO_TOTAL,
	AVG(d.monto) AS MONTO_AVG
FROM DESEMBOLSOS as d
LEFT JOIN MAESTRA_PRODUCTOS AS mp
	ON d.cod_producto = mp.cod_MP
WHERE CAST(LEFT(CAST(d.periodo AS varchar),6) AS INT) BETWEEN  202301 AND 202312 
      AND mp.es_activo = 1 
GROUP BY mp.nombre
ORDER BY MONTO_TOTAL DESC;
GO

/*2.  Obtener el evolutivo anual de desembolsos por cliente y producto. 
Considerar solo los clientes que pertenezcan a la zona LIMA y SUR.*/
SELECT 
	d.cod_cliente,
	mp.nombre,
	SUM(CASE WHEN CAST(LEFT(CAST(d.periodo AS varchar),4) AS INT) = 2020 THEN monto ELSE 0 END) AS [2020],
	SUM(CASE WHEN CAST(LEFT(CAST(d.periodo AS varchar),4) AS INT) = 2021 THEN monto ELSE 0 END) AS [2021],
	SUM(CASE WHEN CAST(LEFT(CAST(d.periodo AS varchar),4) AS INT) = 2022 THEN monto ELSE 0 END) AS [2022],
	SUM(CASE WHEN CAST(LEFT(CAST(d.periodo AS varchar),4) AS INT) = 2023 THEN monto ELSE 0 END) AS [2023],
	SUM(CASE WHEN CAST(LEFT(CAST(d.periodo AS varchar),4) AS INT) = 2024 THEN monto ELSE 0 END) AS [2024]
FROM DESEMBOLSOS AS d
LEFT JOIN MAESTRA_PRODUCTOS AS mp
	ON d.cod_producto = mp.cod_MP 
LEFT JOIN UBIGEO AS u 
	ON d.cod_ubigeo = u.cod_ubigeo
WHERE u.zona IN ('LIMA','SUR')
	AND CAST(LEFT(CAST(d.periodo AS varchar),4) AS INT) BETWEEN 2020 AND 2024
GROUP BY d.cod_cliente, mp.nombre
ORDER BY d.cod_cliente, mp.nombre DESC;
GO

/*3.  Considerando que para el año 2024 solo se cuenta con información hasta julio, 
calcular el monto desembolsado acumulado a Julio por departamento. 
Considerar todas las zonales excepto la de Oriente.
(Acumulado implica que solo se deben considerar los meses de enero a julio).*/
SELECT 
	u.departamento AS DEPARTAMENTO,
	LEFT(CAST(d.periodo AS VARCHAR),4) AS ANIO,
	SUM(d.monto) AS ACUMULADO_JULIO
FROM DESEMBOLSOS AS d
LEFT JOIN UBIGEO AS u
	ON d.cod_ubigeo = u.cod_ubigeo
WHERE CAST(RIGHT(CAST(d.periodo AS varchar),2) AS INT) BETWEEN 1 AND 7
	  AND u.zona != 'ORIENTE'
	  AND CAST(LEFT(CAST(d.periodo AS VARCHAR),4) AS INT) = 2024
GROUP BY u.departamento,LEFT(CAST(d.periodo AS VARCHAR),4)
ORDER BY u.departamento, ANIO;
GO 

/*4.  Escribir la consulta que determine por cliente cuando fue su último desembolso del año 2023,
que producto fue y cuál fue el monto desembolsado.*/
WITH CTE_PERIODO_MAXIMO_2023 AS (
	SELECT 
		cod_cliente,
		MAX(periodo) AS ultimo_periodo
	FROM DESEMBOLSOS
	WHERE LEFT(CAST(periodo AS varchar),4) = 2023
	GROUP BY cod_cliente
), CTE_MAX_ID_PERIODO AS (
	SELECT
		d.cod_cliente AS cod_cli,
		MAX(d.ID) AS max_id
	FROM DESEMBOLSOS as d
	LEFT JOIN CTE_PERIODO_MAXIMO_2023 AS c
		ON c.cod_cliente = c.cod_cliente
	WHERE d.periodo = c.ultimo_periodo
	GROUP BY d.cod_cliente
)
SELECT 
	d.cod_cliente,
	d.periodo,
	mp.nombre,
	d.monto
FROM DESEMBOLSOS AS d
INNER JOIN CTE_MAX_ID_PERIODO AS c
	ON d.ID = c.max_id
LEFT JOIN MAESTRA_PRODUCTOS AS mp
	ON d.cod_producto = mp.cod_MP
ORDER BY d.monto DESC;
GO
