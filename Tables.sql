Create SEQUENCE UserID_sequence
MinValue 1
Increment by 1
Start With 1
Nocache;


Create table User_(
User_ID int primary key,
User_Type varchar2(20) CHECK ( User_Type IN ('RestaurantManager','Customer','Chef','Waiter','Supplier')),
User_Name varchar2(25) not null,
User_PhoneNumber varchar2(15) not null UNIQUE CHECK (REGEXP_LIKE(User_PhoneNumber,'^07[789]\d{7}$')),
User_DateOfBirth Date not null,
User_Email varchar2(40) not null UNIQUE CHECK (REGEXP_LIKE (User_Email, '^(\S+)\@(\S+)\.(\S+)$'))
);
ALTER TABLE User_ ADD User_Pass varchar(50) default 'Abc.123';
ALTER TABLE User_ ADD User_LoginID int default 0;
ALTER TABLE User_
ADD CONSTRAINT FK_UserLoginID
FOREIGN KEY (User_LoginID) REFERENCES Login(Login_ID) ON DELETE SET NULL;


--##############################################################################
--##############################################################################
--##############################################################################

Create SEQUENCE ChefID_sequence
MinValue 1
Increment by 1
Start With 1
Nocache;

Create table Chef(
Chef_ID int primary key,
Chef_Salary number(*,3) not null,
Chef_DateOfHiring Date not null,
Chef_UserID int,
constraint fk_Chef_UserID FOREIGN key (Chef_UserID) REFERENCES User_(User_ID) on delete set null
);


--##############################################################################
--##############################################################################
--##############################################################################
Create SEQUENCE WaiterID_sequence
MinValue 1
Increment by 1
Start With 1
Nocache;

Create table Waiter(
Waiter_ID int primary key,
Waiter_Salary number(*,3) not null,
Waiter_DateOfHiring Date not null,
Waiter_UserID int,
constraint fk_Waiter_UserID FOREIGN key (Waiter_UserID) REFERENCES User_(User_ID) on delete set null
);




--##############################################################################
--##############################################################################
--##############################################################################

Create SEQUENCE SupplierID_sequence
MinValue 1
Increment by 1
Start With 1
Nocache;

Create table Supplier(
Supplier_ID int primary key,
Supplier_ContractSigningDate Date not null,
Supplier_UserID int,
constraint fk_Supplier_UserID FOREIGN key (Supplier_UserID) REFERENCES User_(User_ID) on delete set null
);

--##############################################################################
--##############################################################################
--##############################################################################

Create SEQUENCE ResManID_sequence
MinValue 1
Increment by 1
Start With 1
Nocache;

Create table RestaurantManager(
ResMan_ID int primary key,
ResMan_Salary number(*,3),
ResMan_UserID int,
constraint fk_ResMan_UserID FOREIGN key (ResMan_UserID) REFERENCES User_(User_ID) on delete set null
);



--##############################################################################
--##############################################################################
--##############################################################################

Create SEQUENCE CustomerID_sequence
MinValue 1
Increment by 1
Start With 1
Nocache;

Create table Customer(
Customer_ID int primary key,
Customer_VisaCardNumber varchar(50) not null,
Customer_AvailableBalance NUMBER(20) not null,
Customer_UserID int,
constraint fk_Customer_UserID FOREIGN key (Customer_UserID) REFERENCES User_(User_ID) on delete set null
);

--##############################################################################
--##############################################################################
--##############################################################################

Create SEQUENCE  BoxMoneyID_sequence
MinValue 1
Increment by 1
Start With 1
Nocache;

Create table BoxMoney(
BoxMoney_ID int PRIMARY KEY,
OpeningTime TIMESTAMP WITH LOCAL TIME ZONE,
ClosingTime TIMESTAMP WITH LOCAL TIME ZONE,
ResManID int,
constraint fk_BoxResManID FOREIGN key (ResManID) REFERENCES RestaurantManager(ResMan_ID) on delete set null
);

--##############################################################################
--##############################################################################
--##############################################################################

Create SEQUENCE CategoreyID_sequence
MinValue 1
Increment by 1
Start With 1
Nocache;

Create table Categorey(
Categorey_ID int primary key,
Categorey_Name varchar2(25) not null 
);



--##############################################################################
--##############################################################################
--##############################################################################

Create SEQUENCE productID_sequence
MinValue 1
Increment by 1
Start With 1
Nocache;

create table product(
product_ID int primary key,
product_name varchar(255),
product_price int,
product_Categorey_ID int,
constraint fk_product_Categorey_ID FOREIGN key (product_Categorey_ID)REFERENCES Categorey(Categorey_ID) on delete set null
); 


--##############################################################################
--##############################################################################
--##############################################################################

Create SEQUENCE OrderID_sequence
MinValue 1
Increment by 1
Start With 1
Nocache;


create table Order_(
Order_ID int primary key,
Order_Data TIMESTAMP WITH LOCAL TIME ZONE ,
Order_Type varchar(25) default 'in the hall'  CHECK(Order_Type IN('in the hall','take away')) ,
CustomerCheck varchar(100) default 'Failure to fulfill the order'  CHECK(CustomerCheck IN('Execution of the order','Failure to fulfill the order')) ,
ChefCheck  varchar(100) default 'waiting'  CHECK(ChefCheck IN('waiting','Approval','Disapproval')) ,
Waiter_Chef_StateOrder varchar(100) default 'waiting'  CHECK(Waiter_Chef_StateOrder IN('waiting','Order is in progress','Order Complete')) ,
Order_CustomerID int,
Order_ChefID int default 5,
constraint fk_OrderCustomerID FOREIGN key (Order_CustomerID)REFERENCES Customer(Customer_ID) on delete set null,
constraint fk_OrderChefID FOREIGN key (Order_ChefID)REFERENCES Chef(Chef_ID) on delete set null
);
ALTER TABLE Order_ ADD GiveOrderToCustomer varchar(10) default 'No' CHECK(GiveOrderToCustomer IN('No','Yes'));
ALTER TABLE Order_ ADD BoxMoneyID int default 1;
ALTER TABLE Order_
ADD CONSTRAINT FK_BoxMoneyID
FOREIGN KEY (BoxMoneyID) REFERENCES BoxMoney(BoxMoney_ID);

----------------------##

--##############################################################################
--##############################################################################
--##############################################################################

Create SEQUENCE OrderDetail_sequence
MinValue 1
Increment by 1
Start With 1
Nocache;


create table OrderDetail(
OrderDetail_ID int primary key,
OrderDetail_OrderID int,
OrderDetail_productID int,
OrderDetail_productAmount int default 1,
constraint fk_OrderDetailOrderID FOREIGN key (OrderDetail_OrderID)REFERENCES Order_(Order_ID) on delete set null,
constraint fk_OrderDetailproductID FOREIGN key (OrderDetail_productID)REFERENCES product(product_ID) on delete set null
);



--##############################################################################
--##############################################################################
--##############################################################################

Create SEQUENCE FeedBackID_sequence
MinValue 1
Increment by 1
Start With 1
Nocache;

Create table Customer_FeedBack(
FeedBack_ID int primary key,
FeedBack_Restaurant varchar2(25) CHECK(FeedBack_Restaurant IN('Excellent','Very Good','Good','Bad','No comment')), 
FeedBack_Food varchar2(25) CHECK(FeedBack_Food IN('Excellent','Very Good','Good','Bad','No comment')),
FeedBack_Chef varchar2(25) CHECK(FeedBack_Chef IN('Excellent','Very Good','Good','Bad','No comment')),
FeedBack_Waiter varchar2(25) CHECK(FeedBack_Waiter IN('Excellent','Very Good','Good','Bad','No comment')),
FeedBack_Note varchar2(250),
CustomerID int,
OrderID int,
constraint fk_FeedBack_CustomerID FOREIGN key (CustomerID) REFERENCES Customer(Customer_ID) on delete set null,
constraint fk_FeedBack_OrderID FOREIGN key (OrderID) REFERENCES Order_(Order_ID) on delete set null
);

Select * from Customer_FeedBack;



--##############################################################################
--##############################################################################
--##############################################################################

Create SEQUENCE tableID_sequence
MinValue 1
Increment by 1
Start With 1
Nocache;

create table table_ (
table_ID int primary key,
table_Code varchar(10),
table_Status varchar(25) default 'Available'  CHECK(table_Status IN('Available','Not available'))
);


--##############################################################################
--##############################################################################
--##############################################################################

Create SEQUENCE reservationID_sequence
MinValue 1
Increment by 1
Start With 1
Nocache;


create table reservation(
Booked_ID int primary key,
bookingSession varchar2(50),
bookingDate Date,
tableID int,
CustomerID int,
constraint  fk_resertableID FOREIGN key (tableID) REFERENCES table_(table_ID) on delete set null,
constraint  fk_reserCustomerID FOREIGN key (CustomerID) REFERENCES Customer(Customer_ID) on delete set null
);




--##############################################################################
--##############################################################################
--##############################################################################

Create SEQUENCE InfoID_sequence
MinValue 1
Increment by 1
Start With 1
Nocache;


Create table InfoAboutRestaurant(
Info_ID int PRIMARY KEY,
DateOfEstablishment DATE,
NumberOfTables INT,
OpeningTime TIMESTAMP WITH LOCAL TIME ZONE,
ClosingTime TIMESTAMP WITH LOCAL TIME ZONE,
NumberOfEmployees INT,
TotalSalary Number(*,5)
);
ALTER TABLE InfoAboutRestaurant ADD ResMangId int default 1;
ALTER TABLE InfoAboutRestaurant
ADD CONSTRAINT FK_InfoResMangId
FOREIGN KEY (ResMangId) REFERENCES RestaurantManager(ResMan_ID) ON DELETE SET NULL;



--##############################################################################
--##############################################################################
--##############################################################################

Create SEQUENCE LoginID_sequence
MinValue 1
Increment by 1
Start With 1
Nocache;

Create table Login(
Login_ID int primary key,
Login_Email varchar2(40) CHECK (REGEXP_LIKE (Login_Email, '^(\S+)\@(\S+)\.(\S+)$')),
Login_Pass Varchar2(50)
);


--##############################################################################
--##############################################################################
--##############################################################################

Create SEQUENCE storedID_sequence
MinValue 1
Increment by 1
Start With 1
Nocache;

Create table Stored_(
Item_ID int primary key,
Item_Name varchar2(25) not null,
ItemExpirationDate Date ,
AmountOfItemAvailable varchar2(25),
Notes_ComponentAboutTheItem varchar2(155)
);
ALTER TABLE Stored_ ADD Stored_ResMangId int default 1;
ALTER TABLE Stored_
ADD CONSTRAINT FK_StoredResMangId
FOREIGN KEY (Stored_ResMangId) REFERENCES RestaurantManager(ResMan_ID) ON DELETE SET NULL;

ALTER TABLE Stored_ ADD Stored_SupplierID int default 1;
ALTER TABLE Stored_
ADD CONSTRAINT FK_StoredSupplierID
FOREIGN KEY (Stored_SupplierID) REFERENCES Supplier(Supplier_ID) ON DELETE SET NULL;



--##############################################################################
--##############################################################################
--##############################################################################

Create table Audits(
audit_ID int GENERATED by default on null as IDENTITY primary key,
table_name varchar2(30),
transaction_name varchar2(50),
by_user varchar2(25),
transaction_Date TIMESTAMP WITH LOCAL TIME ZONE
);

--##############################################################################
--##############################################################################
--##############################################################################
Commit;