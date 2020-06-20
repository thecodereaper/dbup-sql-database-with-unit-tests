create or alter procedure Role.[test that when role name is null then should fail insert]
as
begin

	declare @RoleName nvarchar(10) = null;

	exec tSQLt.ExpectException @Message = N'Cannot insert the value NULL into column ''Name'', table ''AuthDB.auth.Role''; column does not allow nulls. INSERT fails.'
							  ,@ExpectedSeverity = 16
							  ,@ExpectedState = 2;

	insert into auth.Role (Name)
	values (@RoleName);
end