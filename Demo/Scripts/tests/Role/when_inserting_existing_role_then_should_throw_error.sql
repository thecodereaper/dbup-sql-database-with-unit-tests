create or alter procedure Role.[test that when inserting existing role then should throw error]
as
begin

	declare @RoleName nvarchar(10) = 'Role_X';
	declare @ErrorMessage nvarchar(max) = N'Cannot insert duplicate key row in object ''auth.Role'' with unique index ''UX_Role_Name''. The duplicate key value is (' + @RoleName + ').';
	insert into auth.Role (Name) values (@RoleName);

	exec tSQLt.ExpectException @Message = @ErrorMessage
							  ,@ExpectedSeverity = 14
							  ,@ExpectedState = 1;

	insert into auth.Role (Name) values (@RoleName);

	delete from auth.Role
	where Name = @RoleName;

end;