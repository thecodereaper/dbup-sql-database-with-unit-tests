create or alter procedure Role.[test that when role name is more than 10 characters then should fail insert]
as
begin

	declare @RoleName nvarchar(20) = 'some really long role name';

	exec tSQLt.ExpectException @Message = N'String or binary data would be truncated.'
							  ,@ExpectedSeverity = 16
							  ,@ExpectedState = 13;

	insert into auth.Role (Name)
	values (@RoleName);

end;