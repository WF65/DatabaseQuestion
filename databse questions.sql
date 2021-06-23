-- database 1

-- database creation
create table HeadOffice (OfficeId int primary key identity(1,1), OfficeName varchar(40) unique,
City varchar(20), Country varchar(20), OfficeAddress varchar(40), Phone nvarchar(24),
Director varchar(40))

create table Project (ProjectCode int primary key identity(200,1), ProjectTitle varchar(40),
StartDate datetime, EndDate datetime, Budget decimal(10,2), PersonInCharge varchar(40))

create table OfficeProjects (OfficeId int foreign key references HeadOffice(OfficeId) on delete set null,
ProjectCode int foreign key references Project(ProjectCode) on delete set null)

create table Operations (OperationId int primary key identity (3000, 1), Title varchar(40) )

create table ProjectOperations(ProjectCode int foreign key references Project(ProjectCode) on delete set null,
OperationId int foreign key references Operations(OperationId) on delete set null)

create table City (CityId int primary key identity (40000, 100), CityName varchar(20), Country varchar(20))

create table OperationCities (OperationId int foreign key references Operations(OperationId) on delete set null, 
CityId int foreign key references City(CityId) on delete set null)

--query
with cteCityOperation
as 
(
select c.CityId + o.OperationId as "identifier", c.CityName,  o.Title, ho.Country
from City c inner join OperationCities oc
on c.CityId = oc.CityId
inner join Operations o
on oc.OperationId = o.OperationId
inner join ProjectOperations po
on oc.OperationId = po.OperationId
inner join Project p
on po.ProjectCode = p.ProjectCode
inner join OfficeProjects op
on p.ProjectCode = op.ProjectCode
inner join HeadOffice ho
on op.OfficeId = ho.OfficeId
), cteOperationCount
as
(
select c.CityId + o.OperationId as "identifier", count(po.OperationId) as "Count"
from  City c inner join OperationCities oc
on c.CityId = oc.CityId
inner join Operations o
on oc.OperationId = o.OperationId
inner join ProjectOperations po
on oc.OperationId = po.OperationId
group by c.CityId, o.OperationId
)
select cco.CityName, cco.Title, cco.Country, coc.count
from cteCityOperation cco inner join cteOperationCount coc
on cco.identifier = coc.identifier

--database 2
create table Lenders (Id int primary key identity(1,1), LenderName varchar(40),
Balance decimal(18,2))

create table Borrowers (Id int primary key identity(100,1), BorrowerName varchar(40),
RiskValue float)

create table Loan (Id int primary key identity(1000,1), 
Borrower int foreign key references Borrowers(Id) on delete set null,
Amount decimal(18,2),
Deadline datetime, InterestRate decimal(3,2), Purpose varchar(200))

create table LoanContribution (LoanId int foreign key references Loan(Id) on delete set null,
Lender int foreign key references Lenders(Id) on delete set null,
Contribution decimal(18,2)
)


--database 3
create table course (Id int primary key identity(1,1), CourseName varchar(20) not null,
CourseDescription varchar(200), Photo image, Price decimal(4,2))

create table Category (Id int primary key identity(1000,1), CategoryName varchar(20) not null,
CategoryDesciption varchar(200), PersonInCharge varchar(40))

create table CourseCategory (CourseId int foreign key references Course(Id) on delete cascade,
Category int foreign key references Category(Id) on delete set null) 

create table recipe (Id int primary key identity (1,1), Title varchar(40) not null)

create table Ingredient(Id int primary key identity (1, 1), Title varchar(40) not null, 
AmountInStore float)

create table MeasurementUnit(Id int primary key identity (1, 1), Title varchar(40) not null)

create table RecipeDetail(RecipeId int foreign key references recipe(Id) on delete cascade, 
IngredientId int foreign key references Ingredient(Id) on delete set null,
Amount decimal(5,2),
MeasurementId int foreign key references MeasurementUnit(Id) on delete set null )