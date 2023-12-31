USE MASTER
GO

CREATE DATABASE Ej_N2

USE Ej_N2
GO

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

SELECT *
FROM PLANTILLA
WHERE APELLIDO LIKE 'S%'

SELECT *
FROM PLANTILLA
WHERE FUNCION='DOCTORA'
AND TURNO IN ('T','M')

SELECT * 
FROM PLANTILLA 
WHERE SALARIO BETWEEN 1500 AND 3500

SELECT HOSPITAL_COD, NOMBRE 
FROM HOSPITAL
ORDER BY NOMBRE

SELECT HOSPITAL.NOMBRE,MAX(SALARIO)
FROM HOSPITAL,PLANTILLA
WHERE HOSPITAL.HOSPITAL_COD=PLANTILLA.HOSPITAL_COD
GROUP BY HOSPITAL.NOMBRE

SELECT HOSPITAL.NOMBRE, MAX(SALARIO)
FROM HOSPITAL
INNER JOIN PLANTILLA ON HOSPITAL.HOSPITAL_COD = PLANTILLA.HOSPITAL_COD
GROUP BY HOSPITAL.NOMBRE

SELECT H.NOMBRE, S.SALA_COD, MAX(P.SALARIO) AS [MAXIMO SALARIO POR SALA]
FROM HOSPITAL H
INNER JOIN SALA S ON H.HOSPITAL_COD = S.HOSPITAL_COD
INNER JOIN PLANTILLA P ON S.SALA_COD = P.SALA_COD AND H.HOSPITAL_COD = P.HOSPITAL_COD
GROUP BY H.NOMBRE, S.SALA_COD

select HOSPITAL.NOMBRE, SALA.SALA_COD , MAX(SALARIO)
from HOSPITAL
INNER JOIN SALA ON SALA.HOSPITAL_COD = HOSPITAL.HOSPITAL_COD
INNER JOIN PLANTILLA ON PLANTILLA.SALA_COD= SALA.SALA_COD
GROUP BY HOSPITAL.NOMBRE, SALA.SALA_COD


SELECT * FROM PLANTILLA 
INNER JOIN SALA ON PLANTILLA.SALA_COD = SALA.SALA_COD

SELECT EMPLEADO_NO , APELLIDO
FROM PLANTILLA
INNER JOIN HOSPITAL ON PLANTILLA.HOSPITAL_COD=HOSPITAL.HOSPITAL_COD AND PLANTILLA.SALARIO>(SELECT PLANTILLA.HOSPITAL_COD,AVG(SALARIO) AS SALARIO_PROMEDIO
FROM PLANTILLA 
INNER JOIN HOSPITAL ON PLANTILLA.HOSPITAL_COD=HOSPITAL.HOSPITAL_COD
GROUP BY PLANTILLA.HOSPITAL_COD).SALARIO_PROMEDIO

SELECT EMPLEADO_NO, APELLIDO, SALARIO
FROM PLANTILLA
INNER JOIN HOSPITAL ON PLANTILLA.HOSPITAL_COD = HOSPITAL.HOSPITAL_COD
WHERE PLANTILLA.SALARIO >= (
  SELECT AVG(SALARIO) AS SALARIO_PROMEDIO
  FROM PLANTILLA 
  WHERE PLANTILLA.HOSPITAL_COD = HOSPITAL.HOSPITAL_COD
  GROUP BY PLANTILLA.HOSPITAL_COD
)



SELECT* FROM PLANTILLA
ORDER BY HOSPITAL_COD

SELECT AVG(SALARIO) AS SALARIO_PROMEDIO
  FROM PLANTILLA , HOSPITAL
  WHERE PLANTILLA.HOSPITAL_COD = HOSPITAL.HOSPITAL_COD
  GROUP BY PLANTILLA.HOSPITAL_COD


INSERT INTO PLANTILLA VALUES (3,2,'Alguien','Enfermero', 'T', 3000000)
SELECT * FROM PLANTILLA

UPDATE ENFERMO SET DIRECCION=NULL 

SELECT * FROM ENFERMO

INSERT INTO ENFERMO VALUES ('D','D',NULL,NULL,NULL),('F','F',NULL,NULL,NULL),('C','C',NULL,NULL,NULL)

UPDATE ENFERMO SET DIRECCION= (SELECT DIRECCION 
FROM ENFERMO 
WHERE INSCRIPCION=7) WHERE INSCRIPCION=6

UPDATE HOSPITAL SET NUM_CAMA=NUM_CAMA*1.1
SELECT *FROM HOSPITAL

CREATE VIEW VistaEnfermos AS
SELECT E.APELLIDO, E.DIRECCION, E.FECHA_NAC, H.NOMBRE AS HOSPITAL
FROM ENFERMO E
JOIN OCUPACION O ON E.INSCRIPCION = O.INSCRIPCION
JOIN HOSPITAL H ON O.HOSPITAL_COD = H.HOSPITAL_COD
SELECT * FROM VistaEnfermos

SELECT * FROM ENFERMO JOIN OCUPACION ON OCUPACION.INSCRIPCION=ENFERMO.INSCRIPCION JOIN HOSPITAL ON HOSPITAL.HOSPITAL_COD= OCUPACION.HOSPITAL_COD
INSERT INTO OCUPACION VALUES(3,1,1,1),(4,2,2,2)
