create or alter procedure Role.[test that primary key constraint exists]
as
begin

	declare @SchemaName nvarchar(max) = N'auth';
	declare @TableName nvarchar(max) = N'Role';
	declare @ConstraintType nvarchar(20) = N'PRIMARY KEY'
	declare @ConstraintName nvarchar(max) = N'PK_Role';
	declare @ColumnName nvarchar(10) = N'Id';
	declare @Exists bit = 0;
	declare @Message nvarchar(max) = 'PK_Role does not exist on table auth.Role.';

	if exists
		(
			select
				tc.table_name
			   ,tc.TABLE_SCHEMA
			   ,ccu.column_name
			   ,ccu.CONSTRAINT_NAME
			from
				INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
				inner join INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE ccu
					on ccu.CONSTRAINT_NAME = tc.CONSTRAINT_NAME
						and ccu.table_name = tc.table_name
			where
				ccu.TABLE_SCHEMA = @SchemaName
				and ccu.table_name = @TableName
				and tc.CONSTRAINT_TYPE = @ConstraintType
				and ccu.CONSTRAINT_NAME = @ConstraintName
				and ccu.column_name = @ColumnName
		)
	begin
		set @Exists = 1;
	end

	exec tSQLt.AssertEquals @Expected = 1
						   ,@Actual = @Exists
						   ,@Message = @Message;

end;
