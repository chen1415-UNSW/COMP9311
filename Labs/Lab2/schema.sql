-- COMP9311 Lab 03 Exercise
-- Schema for simple company database
-- Written by John Shepherd, 2004
-- Modified by YOUR NAME, 2012

create table Employees (
	tfn         char(11)     PRIMARY KEY,
	givenName   varchar(30)  NOT NULL,
	familyName  varchar(30),
	hoursPweek  float
);

create table Departments (
	id          char(3)      PRIMARY KEY,
	name        varchar(100) UNIQUE,
	manager     char(11)     UNIQUE
);

create table DeptMissions (
	department  char(3),
	keyword     varchar(20)，
	PRIMARY KEY (department, keyword)
);

create table WorksFor (
	employee    char(11),
	department  char(3),
	percentage  float
	PRIMARY KEY (employee,department)
);


ALTER TABLE Employees
ADD CONSTRAINT tfn_chk check (tfn ~ '[0-9]{3}-[0-9]{3}-[0-9]{3}');

ALTER TABLE Employees
ADD CONSTRAINT hoursPweek_chk check (hoursPweek >=0 AND hoursPweek <= 168);

ALTER TABLE Departments
ADD CONSTRAINT department_chk check (id ~ '{3}');

ALTER TABLE WorksFor
ADD CONSTRAINT percentage_chk check (percentage > 0 AND percentage <= 100);

