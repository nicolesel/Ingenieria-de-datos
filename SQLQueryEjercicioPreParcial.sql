use master
go

create database EjPreParcial

use EjPreParcial
go

create table EMPLEADO(
	codigo_c varchar(30) not null primary key,
	nombre varchar(30) not null,
	edad int not null,
	oficio varchar(30) not null,
	dir varchar(30)not null,
	fecha_alt date not null,
	salario int not null,
	comision int not null,
	depto_no int not null constraint fk_depto_no foreign key(depto_no) references DEPARTAMENTO(depto_no)
);
create table DEPARTAMENTO(
	depto_no int primary key not null,
	nombre_depto varchar(30) not null,
	localizacion varchar(30) not null
);

alter TABLE DEPARTAMENTO 
add CONSTRAINT CH_MAX_DEPTO
CHECK (depto_no <=100)

create procedure DatosTablaEmpleados
@codigo_c varchar(30) ='%',
@nombre varchar(30) ='%',
@edad int,
@oficio varchar(30)='%',
@dir varchar(30)='%',
@fecha_alt date,
@salario int,
@comision int,
@depto_no int
as
insert into EMPLEADO values (@codigo_c,@nombre,@edad,@oficio,@dir,@fecha_alt,@salario,@comision,@depto_no)
go

create procedure DatosTablaDepartamento
@depto_no int,
@nombre_depto varchar(30)='%',
@localizacion varchar(30)='%'
as insert into departamento values (@depto_no,@nombre_depto,@localizacion)
go

exec DatosTablaDepartamento 10,'Desarrollo Software','El Coyolar'
exec DatosTablaDepartamento 20,'Analisis Sistema','Guadalupe'
exec DatosTablaDepartamento 30,'Contabilidad','Subtiava'
exec DatosTablaDepartamento 40,'Ventas','San Felipe'
exec DatosTablaDepartamento 0,'',''
select * from DEPARTAMENTO

exec DatosTablaEmpleados '281-160483-0005F','Rocha Vargas Hector',27,'Vendedor','Leon','1983-05-12',12000,0,40
exec DatosTablaEmpleados '281-040483-0056P','Lopez Hernandez Julio',27,'Analista','Chinandega','1982-07-14',13000,1500,20
exec DatosTablaEmpleados '281-130678-0004S','Esquivel Jose',31,'Director','Juigalpa','1961-06-05',16700,1200,30
exec DatosTablaEmpleados '281-160473-0009Q','Delgado Carmen',37,'Vendedor','Leon','1983-03-02',13400,0,40
exec DatosTablaEmpleados '281-160493-0005F','Castillo Montes Luis',17,'Vendedor','Masaya','1982-08-12',16309,1000,40
exec DatosTablaEmpleados '281-240783-0004Y','Esquivel Leonel Alfonso',26,'Presidente','Nagarote','1981-09-12',15000,0,30
exec DatosTablaEmpleados '281-161277-0008R','Perez Luis',32,'Empleado','Managua','1980-03-02',16890,0,10
select * from EMPLEADO

/**Mostrar los nombres de los empleados alfabéticamente de forma descendiente **/
select nombre from EMPLEADO order by nombre desc

/**Seleccionar el nombre, el oficio xy la localidad de los departamentos donde trabajan los vendedores **/
select nombre, oficio,localizacion from EMPLEADO
inner join DEPARTAMENTO on DEPARTAMENTO.depto_no = EMPLEADO.depto_no

/**Listar los nombres de los empleados cuyo nombre termine con la letra o **/
select nombre from EMPLEADO
where nombre like '%o'

/**Seleccionar el nombre, el oficio y salario de los empleados que trabajan en León **/
select nombre, oficio,salario from EMPLEADO
where dir='Leon'

/**Seleccionar el nombre, salario y localidad donde trabajan de los empleados que tengan un salario entre 10000 y 13000 **/
select nombre, salario, localizacion from EMPLEADO
inner join DEPARTAMENTO on DEPARTAMENTO.depto_no = EMPLEADO.depto_no
where salario between 10000 and 13000

/** Visualizar los departamentos con más de 5 empleados **/
select D.nombre_depto  
from DEPARTAMENTO as D
inner join EMPLEADO as E on E.depto_no = D.depto_no
group by D.nombre_depto
having count(codigo_c)>=2

/** Mostrar el nombre, salario y nombre del departamento de los empleados que tengan el mismo oficio que Leonel Alfonso Esquivel **/
select nombre, salario,nombre_depto from EMPLEADO
inner join DEPARTAMENTO on DEPARTAMENTO.depto_no = EMPLEADO.depto_no
where oficio=(select oficio from EMPLEADO where nombre='Esquivel Leonel Alfonso')

/** Mostrar el nombre, salario y nombre del departamento de los empleados que tengan el mismo oficio que Castillo Montes Luis y que no tengan comisión2 **/
select nombre, salario, nombre_depto from EMPLEADO
inner join DEPARTAMENTO on DEPARTAMENTO.depto_no = EMPLEADO.depto_no
where oficio = (select oficio from EMPLEADO where nombre='Castillo Montes Luis')
and comision=0

/**Mostrar los datos de los empleados que trabajan en el departamento de contabilidad, ordenados por nombre **/
select EMPLEADO.* from EMPLEADO
inner join DEPARTAMENTO on DEPARTAMENTO.depto_no = EMPLEADO.depto_no
where nombre_depto='Contabilidad'
order by nombre

/**Nombre de los empleados que trabajan en León y cuyo oficio sea analista o empleado **/
select nombre from EMPLEADO
where dir='Leon'
and oficio in ('Analista','Empleado')

/**Calcula el salario medio de todos los empleados **/
select avg(salario) as [Salario Promedio] from EMPLEADO

/**¿Cuál es el máximo salario de los empleados del departamento 10? **/
select max(salario) as [MAX salario] from EMPLEADO
where depto_no=10

/** Calcula el salario mínimo de los empleados del departamento ‘VENTAS’**/
select min(salario) as [MIN salario] from EMPLEADO
inner join DEPARTAMENTO on DEPARTAMENTO.depto_no = EMPLEADO.depto_no
where nombre_depto='Ventas'

/**Calcula el promedio del salario de los empleados del departamento de ‘CONTABILIDAD’ **/
select avg(salario) AS AVERAGE
from DEPARTAMENTO
inner join EMPLEADO on EMPLEADO.depto_no=DEPARTAMENTO.depto_no
where nombre_depto='CONTABILIDAD'

/** ¿Cuántos empleados hay en el departamento número 10? **/
SELECT COUNT(*)
FROM EMPLEADO
INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.depto_no=EMPLEADO.depto_no
WHERE DEPARTAMENTO.depto_no=10

/**Calcula el número de empleados que no tienen comisión**/
SELECT COUNT (*)
FROM EMPLEADO
WHERE comision=0

/**Visualizar cuántos nombres de los empleados empiezan por la letra ‘A’**/
SELECT COUNT(*)
FROM EMPLEADO
WHERE nombre LIKE 'A%'

/**Visualizar el número de empleados de cada departamento **/
select nombre_depto, count(*)
from EMPLEADO
INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.depto_no=EMPLEADO.depto_no
group by nombre_depto
/**Para cada oficio obtener la suma de salarios **/
select oficio, sum(salario) as [suma de salario]
from EMPLEADO
group by oficio

/**Mostrar los datos de los empleados cuyo salario sea mayor que la media de todos los salarios **/
select EMPLEADO.*
FROM EMPLEADO
WHERE salario>(SELECT AVG(salario) FROM EMPLEADO)

/*Mostrar los datos del empleado que tiene el salario más alto en el departamento de ‘VENTAS’ 

ESTA BIEN???

*/


SELECT EMPLEADO.* 
FROM EMPLEADO
INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.depto_no = EMPLEADO.depto_no
WHERE nombre_depto='VENTAS'
AND SALARIO=(SELECT MAX(SALARIO)
FROM EMPLEADO
INNER JOIN DEPARTAMENTO ON DEPARTAMENTO.depto_no = EMPLEADO.depto_no
WHERE nombre_depto='VENTAS')

/*Doblar el salario a todos los empleados del departamento 30 */
UPDATE EMPLEADO SET salario=salario*2 WHERE depto_no=30

/*Cambiar todos los empleados del departamento número 30 al departamento número 20 */
UPDATE EMPLEADO SET depto_no=20 WHERE depto_no=30

/*Incrementar en un 10% el sueldo de los empleados del departamento 10 */
UPDATE EMPLEADO SET salario=salario*1.1 WHERE depto_no=10

/*Cambiar la localidad del departamento número 10 a ‘Zaragoza’ */
UPDATE DEPARTAMENTO SET localizacion='ZARAGOZA' WHERE depto_no=10
SELECT * FROM EMPLEADO
/*Igualar el salario de ‘Esquivel Jose’ al salario de ‘Esquivel Leonel Alfonso’ */
UPDATE EMPLEADO SET salario=(SELECT salario FROM EMPLEADO WHERE nombre='ESQUIVEL LEONEL ALFONSO') WHERE NOMBRE='ESQUIVEL JOSE'

/*En la tabla DEPARTAMENTO borrar el departamento número 40

DA ERROR PQ PRIMERO HAY QUE ELIMINAR LOS DE LA TABLA EMPLEADO PQ SON FK

*/
DELETE  FROM DEPARTAMENTO WHERE depto_no=40

/*Borrar de la tabla EMPLEADO todos los empleados que no tengan comisión*/
DELETE FROM EMPLEADO WHERE comision=0
SELECT * FROM EMPLEADO