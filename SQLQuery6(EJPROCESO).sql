CREATE TABLE HOSPITAL( 
           HOSPITAL_COD INT IDENTITY(1,1), 
           NOMBRE        VARCHAR(15), 
           DIRECCION     VARCHAR(20), 
           TELEFONO      CHAR(8), 
           NUM_CAMA      INT, 
CONSTRAINT HOSPITAL_PK PRIMARY KEY (HOSPITAL_COD) 
); 

CREATE TABLE SALA( 
            HOSPITAL_COD  INT  NOT NULL,  
            SALA_COD      INT IDENTITY(1,1), 
            NOMBRE        VARCHAR(20),  
            NUM_CAMA       INT,  
CONSTRAINT SALA_PK PRIMARY KEY (SALA_COD), 
CONSTRAINT HOSPITAL_SALA_FK FOREIGN KEY (HOSPITAL_COD)REFERENCES HOSPITAL (HOSPITAL_COD) 
); 

CREATE TABLE PLANTILLA ( 
            HOSPITAL_COD  INT    NOT   NULL,  
            SALA_COD       INT    NOT NULL,  
            EMPLEADO_NO    INT IDENTITY(1,1), 
            APELLIDO       VARCHAR(15), 
            FUNCION        CHAR(10), 
            TURNO          CHAR (1) , 
            SALARIO        INT, 
CONSTRAINT EMPLEADO_PK PRIMARY KEY (EMPLEADO_NO), 
CONSTRAINT HOSPITAL_FK FOREIGN KEY (HOSPITAL_COD)REFERENCES HOSPITAL (HOSPITAL_COD),  
CONSTRAINT SALA_FK FOREIGN KEY (SALA_COD)REFERENCES SALA (SALA_COD), 
CONSTRAINT TURNO_CH CHECK (TURNO IN ('T','M','N')),  
CONSTRAINT SALARIO_CH CHECK (SALARIO > 0) 
); 

CREATE TABLE ENFERMO ( 
             INSCRIPCION    INT IDENTITY(1,1),  
             APELLIDO       VARCHAR(15),  
             DIRECCION      VARCHAR(20), 
             FECHA_NAC      DATE, 
             S              VARCHAR(1), 
             NSS            INT, 
CONSTRAINT ENFERMO_PK PRIMARY KEY (INSCRIPCION) 
); 

CREATE TABLE OCUPACION( 
             INSCRIPCION    INT,  
             HOSPITAL_COD   INT, 
             SALA_COD       INT, 
             CAMA           INT, 
CONSTRAINT OCUPACION_PK PRIMARY KEY (INSCRIPCION,HOSPITAL_COD,SALA_COD),              
CONSTRAINT HOSPITAL_OCUP_FK FOREIGN KEY (HOSPITAL_COD) REFERENCES HOSPITAL (HOSPITAL_COD),  
CONSTRAINT SALA_OCUP_FK FOREIGN KEY (SALA_COD) REFERENCES SALA (SALA_COD) 
); 

INSERT INTO HOSPITAL(NOMBRE, DIRECCION,TELEFONO,NUM_CAMA) VALUES
('ALVAREZ', 'FLORES','123',10),
('SWUISSO','ONCE','456',20),
('ARCOS','PALERMO','789',30)

INSERT INTO SALA(HOSPITAL_COD,NUM_CAMA)VALUES
(1,1),(2,2),(2,3),(3,4),(3,5),(3,6)

INSERT INTO PLANTILLA(HOSPITAL_COD,SALA_COD,APELLIDO,FUNCION,TURNO,SALARIO)VALUES
(1,1,'SELEM','DOCTORA','M',1000),
(2,2,'SAID','TRABAJADOR','T',2000),
(2,3,'COHEN','MAMA','N',3000),
(3,4,'SAID','PRIMA','M',4000),
(3,4,'SELEM','DOCTORA','M',5000),
(3,5,'MICHA','AMIGA','T',6000)

INSERT INTO PLANTILLA(HOSPITAL_COD,SALA_COD,APELLIDO,FUNCION,TURNO,SALARIO)VALUES
(1,1,'CHIRA','DOCTORA','T',1000)

INSERT INTO PLANTILLA(HOSPITAL_COD,SALA_COD,APELLIDO,FUNCION,TURNO,SALARIO)VALUES
(1,2,'ADRI','DOCTOR','M',1000)

create procedure miembrosComienzan @letra char (1)='%' as
select * from PLANTILLA where APELLIDO like  @letra + '%'

EXEC miembrosComienzan 'S'

create procedure encargadoXturno1 @cargo varchar(20)='%',@turno char(1)='%' as 
select * from plantilla where funcion LIKE @cargo AND TURNO LIKE @turno

EXEC encargadoXturno1 'DOCTOR','N'


INSERT INTO ENFERMO VALUES ('D','D',NULL,NULL,NULL),('F','F',NULL,NULL,NULL),('C','C',NULL,NULL,NULL)

CREATE PROCEDURE enfermerosSalario @from INT, @to INT, @FUNCION VARCHAR(20)= '%' AS
select * from PLANTILLA where SALARIO between @from and @to and FUNCION LIKE @FUNCION

EXEC enfermerosSalario 1500,6000,'DOCTORA'

CREATE PROCEDURE MostrarHospitales as
select HOSPITAL_COD,  from HOSPITAL



CREATE PROCEDURE mostrarHospitales as
select HOSPITAL_COD,NOMBRE from HOSPITAL ORDER BY NOMBRE

EXEC MostrarHospitales

CREATE PROCEDURE maxSalario as
select HOSPITAL.NOMBRE, SALA.SALA_COD, MAX(SALARIO)
FROM HOSPITAL
INNER JOIN SALA ON SALA.HOSPITAL_COD = HOSPITAL.HOSPITAL_COD
INNER JOIN PLANTILLA ON PLANTILLA.SALA_COD = SALA.SALA_COD
GROUP BY HOSPITAL.NOMBRE, SALA.SALA_COD

EXEC maxSalario

select HOSPITAL.NOMBRE, SALA.SALA_COD , MAX(SALARIO)
from HOSPITAL
INNER JOIN SALA ON SALA.HOSPITAL_COD = HOSPITAL.HOSPITAL_COD
INNER JOIN PLANTILLA ON PLANTILLA.SALA_COD= SALA.SALA_COD
GROUP BY HOSPITAL.NOMBRE, SALA.SALA_COD

CREATE PROCEDURE salMaxMediaHospital as
SELECT P1.EMPLEADO_NO, P1.APELLIDO 
FROM PLANTILLA AS P1
WHERE P1.SALARIO> (SELECT AVG(P2.SALARIO) 
FROM PLANTILLA AS P2
INNER JOIN HOSPITAL ON HOSPITAL.HOSPITAL_COD = P2.HOSPITAL_COD
WHERE P1.HOSPITAL_COD=P2.HOSPITAL_COD)

exec salMaxMediaHospital



create procedure agregarWorker @hospitalcod int,@salacod int,@apellido varchar(20)='%',@funcion varchar(20)='%',@turno char(1)='%',@salario int as
insert into PLANTILLA values (@hospitalcod,@salacod,@apellido,@funcion,@turno,@salario)



CREATE PROCEDURE cambiarPaciente @inscripcion int,@apellido VARCHAR(20)='%',@direccion VARCHAR(20)='%',@fechanac date,@s VARCHAR(1)='%',@nss int as
update ENFERMO set APELLIDO=@apellido,DIRECCION=@direccion,FECHA_NAC=@fechanac,S=@s,NSS=@nss where INSCRIPCION=@inscripcion

exec cambiarPaciente 3,'','MADRID 411','','',''

CREATE PROCEDURE direcEnfermoNull AS
update ENFERMO set DIRECCION=NULL 

exec direcEnfermoNull

create procedure changeApellido @inscripcion1 int,@inscripcion2 int as
update ENFERMO SET APELLIDO=(SELECT APELLIDO FROM ENFERMO WHERE INSCRIPCION=@inscripcion2) WHERE INSCRIPCION=@inscripcion1

EXEC changeApellido 4,5

CREATE PROCEDURE aumentoCamasPorcentaje @porcentaje int as
update HOSPITAL set NUM_CAMA=NUM_CAMA*(1+@porcentaje/100)

exec aumentoCamasPorcentaje 100

select * from HOSPITAL


CREATE VIEW vistaEnfermoss AS 
select ENFERMO.APELLIDO,ENFERMO.DIRECCION,ENFERMO.FECHA_NAC,HOSPITAL.NOMBRE 
from ENFERMO 
INNER JOIN OCUPACION ON OCUPACION.INSCRIPCION=ENFERMO.INSCRIPCION
INNER JOIN HOSPITAL ON HOSPITAL.HOSPITAL_COD=OCUPACION.HOSPITAL_COD

CREATE PROCEDURE ConsultarEnfermos as
select* from VistaEnfermoss

exec ConsultarEnfermos

select * from ENFERMO