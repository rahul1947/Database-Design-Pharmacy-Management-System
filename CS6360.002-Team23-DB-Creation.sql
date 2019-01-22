/*
CS6360: Database Design - Pharmacy Management System
Team 23:
Rahul Nalawade (rsn170330)
Ishan Sharma (ixs171130)
*/

DROP TABLE if exists Customer;
CREATE TABLE Customer (
    SSN               number(10) NOT NULL, 
    First Name        char(255) NOT NULL, 
    Last Name         char(255) NOT NULL, 
    Phone             number(10) NOT NULL UNIQUE, 
    Gender            char(1) NOT NULL, 
    Address           char(1000) NOT NULL, 
    Date of Birth     date NOT NULL, 
    Insurance ID      number(10) NOT NULL UNIQUE, 

    PRIMARY KEY (SSN)
);

ALTER TABLE Customer ADD CONSTRAINT insures FOREIGN KEY (Insurance ID) 
    REFERENCES Insurance (Insurance ID) ON DELETE Set null;

DROP TABLE if exists Prescription;
CREATE TABLE Prescription (
    Prescription ID   number(10) NOT NULL, 
    SSN               number(10) NOT NULL, 
    Doctor ID         number(10) NOT NULL, 
    Prescribed Date   date NOT NULL, 
    
    PRIMARY KEY (Prescription ID)
);

ALTER TABLE Prescription ADD CONSTRAINT holds FOREIGN KEY (SSN) 
    REFERENCES Customer (SSN);

CREATE TABLE Prescribed Drugs (
    Prescription ID       number(10) NOT NULL, 
    Drug Name             char(255) NOT NULL, 
    Prescribed Quantity   number(10) NOT NULL, 
    Refill Limit          number(10) NOT NULL, 
    
    PRIMARY KEY (Prescription ID, Drug Name)
);

ALTER TABLE Prescribed Drugs ADD CONSTRAINT consists of FOREIGN KEY (Prescription ID) 
    REFERENCES Prescription (Prescription ID) ON DELETE Cascade;

DROP TABLE if exists Order;
CREATE TABLE Order (
    Order ID          number(10) NOT NULL, 
    Prescription ID   number(10) NOT NULL, 
    EmployeeID        number(5) NOT NULL, 
    Order Date        date NOT NULL, 

    PRIMARY KEY (Order ID)
);

ALTER TABLE Order ADD CONSTRAINT prepares FOREIGN KEY (EmployeeID) 
    REFERENCES Employee (ID);
ALTER TABLE Order ADD CONSTRAINT uses FOREIGN KEY (Prescription ID) 
    REFERENCES Prescription (Prescription ID);

CREATE TABLE Ordered Drugs (
    Order ID            number(10) NOT NULL, 
    Drug Name           char(255) NOT NULL, 
    Batch Number        number(10) NOT NULL, 
    Ordered Quantity    number(10) NOT NULL, 
    Price               number(2) NOT NULL, 

    PRIMARY KEY (Order ID, Drug Name, Batch Number)
);

ALTER TABLE Ordered Drugs ADD CONSTRAINT contains FOREIGN KEY (Order ID) 
    REFERENCES Order (Order ID) ON DELETE Cascade;
ALTER TABLE Ordered Drugs ADD CONSTRAINT Fulfilled From FOREIGN KEY (Drug Name, Batch Number) 
    REFERENCES Medicine (Drug Name, Batch Number);

DROP TABLE if exists Insurance;
CREATE TABLE Insurance (
    Insurance ID    number(10) NOT NULL, 
    Company Name    char(255) NOT NULL, 
    Start Date      date NOT NULL, 
    End Date        date NOT NULL, 
    Co-Insurance    number(4) NOT NULL, 
    
    PRIMARY KEY (Insurance ID)
);

CREATE INDEX Insurance_Company Name 
    ON Insurance (Company Name);

DROP TABLE if exists Employee;
CREATE TABLE Employee (
    ID                number(5) NOT NULL, 
    SSN               number(10) NOT NULL UNIQUE, 
    License           number(10) UNIQUE, 
    First Name        char(255) NOT NULL, 
    Last Name         char(255) NOT NULL, 
    Start Date        date NOT NULL, 
    End Date          date, 
    Role              char(255) NOT NULL, 
    Salary            number(4) NOT NULL, 
    Phone Number      number(10) NOT NULL, 
    Date of Birth     date NOT NULL, 

    PRIMARY KEY (ID)
);

CREATE TABLE Medicine (
    Drug Name           char(255) NOT NULL, 
    Batch Number        number(10) NOT NULL, 
    MedicineType        char(255) NOT NULL, 
    Manufacturer        char(255) NOT NULL, 
    Stock Quantity      number(10) NOT NULL, 
    Expiry Date         date NOT NULL, 
    Price               number(4) NOT NULL, 

    PRIMARY KEY (Drug Name, Batch Number)
);

CREATE TABLE Bill (
    Order ID            number(10) NOT NULL, 
    CustomerSSN         number(10) NOT NULL, 
    Total Amount        number(4) NOT NULL, 
    Customer Payment    number(4) NOT NULL, 
    Insurance Payment   number(4) NOT NULL, 
    
    PRIMARY KEY (Order ID, CustomerSSN)
);

ALTER TABLE Bill ADD CONSTRAINT makes FOREIGN KEY (Order ID) 
    REFERENCES Order (Order ID);
ALTER TABLE Bill ADD CONSTRAINT pays FOREIGN KEY (CustomerSSN) 
    REFERENCES Customer (SSN);

CREATE TABLE Disposed Drugs (
    Drug Name       char(255) NOT NULL, 
    Batch Number    number(10) NOT NULL, 
    Quantity        number(10) NOT NULL, 
    Company         char(255) NOT NULL, 

    PRIMARY KEY (Drug Name, Batch Number)
);

ALTER TABLE Disposed Drugs ADD CONSTRAINT disposed FOREIGN KEY (Drug Name, Batch Number) 
    REFERENCES Medicine (Drug Name, Batch Number);

DROP TABLE if exists Notification;
CREATE TABLE Notification (
    ID              number(10) NOT NULL, 
    Message         char(255) NOT NULL, 
    Type            char(255) NOT NULL, 

    PRIMARY KEY (ID)
);

CREATE TABLE Employee_Notification (
    EmployeeID        number(5) NOT NULL, 
    NotificationID    number(10) NOT NULL, 
    
    PRIMARY KEY (EmployeeID, NotificationID)
);

ALTER TABLE Employee_Notification ADD CONSTRAINT FKEmployee_N849182 FOREIGN KEY (EmployeeID) 
    REFERENCES Employee (ID) ON DELETE Cascade;
ALTER TABLE Employee_Notification ADD CONSTRAINT FKEmployee_N664471 FOREIGN KEY (NotificationID) 
    REFERENCES Notification (ID) ON DELETE Cascade;

CREATE TABLE Employee_Disposed Drugs (
    EmployeeID        number(5) NOT NULL, 
    Drug Name         char(255) NOT NULL, 
    Batch Number      number(10) NOT NULL, 
    Disposal Date     date NOT NULL, 
    
    PRIMARY KEY (EmployeeID, Drug Name, Batch Number, Disposal Date)
);

ALTER TABLE Employee_Disposed Drugs ADD CONSTRAINT FKEmployee_D470142 FOREIGN KEY (EmployeeID) 
    REFERENCES Employee (ID);
ALTER TABLE Employee_Disposed Drugs ADD CONSTRAINT FKEmployee_D990025 FOREIGN KEY (Drug Name, Batch Number) 
    REFERENCES Disposed Drugs (Drug Name, Batch Number);
