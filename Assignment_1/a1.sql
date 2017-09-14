-- COMP9311 16s2 Assignment 1
-- Schema for KensingtonCars
--
-- Written by hao chen
-- Student ID: z5102446

-- Some useful domains; you can define more if needed.



-- EMPLOYEE part
 

-- // Domain used by EMPLOYEE part

create domain TFNType as char(9)      
	check (value ~ '[0-9]{9}');

create domain MechanicLicenseType as char(9)      
	check (value ~ '[0-9A-Za-z]{8}');

-- // 


-- Table Employee

create table Employee (
	EID          serial, 
	firstname    varchar(50) not null,
	lastname     varchar(50) not null,
        Salary       integer     not null check (Salary > 0),
        TFN          TFNType     not null,
	primary key (EID)
);


-- Table Admin

create table "Admin" (
	EID          integer     references Employee(EID), 
	primary key (EID)
);

-- Table Mechanic

create table Mechanic (
        EID          integer             references Employee(EID),
        license      MechanicLicenseType not null,
	primary key (EID)
);


-- Table Salesman

create table Salesman (
	EID          integer references Employee(EID),
        commRate     integer check (commRate >= 5 and commRate <= 20) not null,
	primary key (EID)
);





-- CLIENT and CAR part


-- // Domain used by CLIENT and CAR part

create domain PhoneType as char(10)     
	check (value ~ '[0-9]{10}');

create domain EmailType as varchar(100) 
	check (value like '%@%.%');

create domain ABNType as char(11) 
	check (value ~ '[0-9]{11}');

create domain URLType as varchar(100) 
        check (value like 'http://%');

create domain VINType as char(17)
        check (value ~ '[0-9A-HJ-NPR-Za-hj-npr-z]{17}');

create domain OptionType as varchar(12)
        check (value in ('sunroof','moonroof','GPS','alloy wheels','leather'));

create domain CarLicenseType as char(6) 
	check (value ~ '[0-9A-Za-z]{6}');

-- //


-- Table Client

create table Client (
    CID          serial,
    "name"       varchar(100) not null,
    address      varchar(200) not null,
    phone        PhoneType    not null,
    email        EmailType,
    primary key (CID)
);    -- emial?????

-- Table Company

create table Company (
    CID          integer references Client(CID),
    ABN          ABNType not null,
    url          URLType,
    primary key (CID)
); 


-- Table Car

create table Car(
    VIN          VINType,
    "year"       integer      check ("year" >= 1970 and "year" <= 2099) not null,
    model        varchar(40)  not null,
    manufacturer varchar(40)  not null,
    primary key (VIN)
);

-- Table CarOptions

create table CarOptions(
    VIN          VINType      references Car(VIN),
    CarOptions   OptionType,
    primary key (VIN,CarOptions)  
);

-- Tabel NewCar

create table NewCar(
    VIN          VINType      references Car(VIN),
    cost         numeric(8,2) check(cost > 0) not null,
    charges      numeric(8,2) check(charges > 0) not null,
    primary key (VIN)  
);

-- Tabel UsedCar

create table UsedCar(
    VIN          VINType      references Car(VIN),
    plateNumber  CarLicenseType not null,
    primary key (VIN)  
);





-- BUY,SELL and REPAIR part
 
-- // Domain used by BUY,SELL and Repair part

-- NULL

-- // 


-- Table RepairJob

create table RepairJob(
    VIN          VINType      references UsedCar(VIN),
    "number"     integer      check("number">=1 and "number"<=999) not null,
    "date"       date         not null,
    CID          integer      references Client(CID),
    parts        numeric(8,2) check(parts > 0) not null,
    work         numeric(8,2) check(work > 0) not null,
    description  varchar(250),
    primary key (VIN,"number")  
);

-- Table Dose

create table Does(
    EID          integer       references Mechanic(EID), 
    VIN          VINType,
    "number"     integer,
    foreign key (VIN,"number") references RepairJob(VIN,"number"),
    primary key (EID, VIN,"number")
);

-- Table Buys

create table Buys(
    EID         integer        references Salesman(EID),
    CID         integer        references Client(CID),
    VIN         VINType        references UsedCar(VIN),
    price       numeric(8,2)   check(price > 0) not null,
    "date"      date           not null,
    commission  numeric(8,2)   check(price > 0) not null,
    primary key (CID,VIN,"date") --receibver doesn't matter
);

-- Table Sells

create table Sells (
    EID         integer      references Salesman(EID),
    CID         integer      references Client(CID),
    VIN         VINType      references UsedCar(VIN),
    "date"      date         not null,
    price       numeric(8,2) check (price > 0) not null,
    commission  numeric(8,2) check (commission > 0) not null,
    primary key (EID,VIN,"date") 
);

-- Table SellsNew

create table SellsNew (
    EID           integer        references Salesman(EID),
    CID           integer        references Client(CID),
    VIN           VINType        references NewCar(VIN),
    price         numeric(8,2)   check (price > 0) not null,
    "date"        date           not null,
    commission    numeric(8,2)   check (commission > 0) not null,
    plateNumber   CarLicenseType not null,
    primary key (EID,VIN,"date")  
);

