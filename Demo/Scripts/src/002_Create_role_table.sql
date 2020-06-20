create table [auth].[Role]
(
	Id tinyint not null identity
   ,[Name] nvarchar(10) not null
   ,constraint PK_Role primary key (Id)
);

create unique index UX_Role_Name on [auth].[Role] ([Name]);