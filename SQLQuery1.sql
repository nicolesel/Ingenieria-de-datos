use master
go

Create database Prueba

use Prueba
go

Create table Person(
	IdPerson int primary key not null,
	NombrePersona varchar(10) not null,
	Genero char(1) check(Genero in('M', 'F', 'N')) not null
);

Create Table Orders(
	OrderId int not null,
	OrderNumber int not null,
	PersonId int not null,
	Primary key (OrderId, OrderNumber), 
	Constraint FK_PersonOrder foreign key (PersonId) References Person(IdPerson)
);

Insert into Person(IdPerson, NombrePersona, Genero)
values (01,'Nicole', 'F');

select * from Person;

insert into Person (IdPerson,NombrePersona,Genero)Values
(02,'Oriana','F'),
(03,'Tomy','M'),
(04,'Silvina','F'),
(05,'Claudio','M'),
(06,'Lizardo','N');

select * from Person

select NombrePersona as Nombre , Genero
from Person
where Genero='F'

select NombrePersona
from Person
where NombrePersona like 'N%'

update Person
set NombrePersona='Chiara'
where NombrePersona='Lizardo'

select * from Person

Insert into Person(IdPerson, NombrePersona, Genero)
values (07,'Nicole', 'F');

select * from Person

Select distinct NombrePersona
from Person