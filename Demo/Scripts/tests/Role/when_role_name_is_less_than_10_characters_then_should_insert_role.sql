create or alter procedure Role.[test that when role name is less than 10 characters then should insert role]
as
begin

	--Arrange
	declare @RoleName nvarchar(10) = 'Test Role';
	declare @RoleId tinyint = 0;

	--Act
	insert into auth.Role(Name)
	values (@RoleName);
	select @RoleId = @@Identity;

	--Assert
	exec tSQLt.AssertNotEquals @Expected = 0
							  ,@Actual = @RoleId
							  ,@Message = N'RoleId was not incremented';

	--Clean up
	delete from auth.Role
	where Id = @RoleId;

end