SET NOCOUNT ON
GO

USE Master
GO

IF NOT EXISTS(SELECT 1 FROM sys.databases WHERE name = 'HierDemo') CREATE DATABASE HierDemo
GO

USE HierDemo
GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE name = 'OldStyle') DROP TABLE OldStyle
GO

CREATE TABLE OldStyle
( 
	id INTEGER IDENTITY PRIMARY KEY
	, name VARCHAR(1000) NOT NULL
	, parentID INTEGER NULL
)
GO

CREATE UNIQUE NONCLUSTERED INDEX NC_oldStyle_name ON OldStyle(name)
GO

ALTER TABLE OldStyle
ADD CONSTRAINT FK_OldStyle_Parent FOREIGN KEY (parentID)
    REFERENCES OldStyle(id)
GO 

IF EXISTS(SELECT 1 FROM sys.objects WHERE name = 'ufnOldStleID') DROP FUNCTION dbo.ufnOldStleID
GO

CREATE FUNCTION ufnOldStleID( @name VARCHAR(1000))
RETURNS INTEGER
AS
BEGIN
	RETURN ISNULL((SELECT id FROM OldStyle WHERE name = @name), 0)
END;
GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE name = 'ufnOldStleParentID') DROP FUNCTION dbo.ufnOldStleParentID
GO

CREATE FUNCTION ufnOldStleParentID( @name VARCHAR(1000))
RETURNS INTEGER
AS
BEGIN
	RETURN ISNULL((SELECT parentID FROM OldStyle WHERE name = @name), 0)
END;
GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE name = 'ufnOldStleParentName') DROP FUNCTION dbo.ufnOldStleParentName
GO

CREATE FUNCTION ufnOldStleParentName( @name VARCHAR(1000))
RETURNS VARCHAR(1000)
AS
BEGIN
	RETURN (SELECT name	FROM OldStyle WHERE id = dbo.ufnOldStleParentID(@name))
END;
GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE name = 'ufnOldStleIsChildOf') DROP FUNCTION dbo.ufnOldStleIsChildOf
GO

CREATE FUNCTION ufnOldStleIsChildOf( @child VARCHAR(1000), @required VARCHAR(1000))
RETURNS BIT
AS
BEGIN
	DECLARE @parentName VARCHAR(1000)
	
	SELECT @parentName = dbo.ufnOldStleParentName(@child)

	IF @parentName = @required RETURN @parentName

	IF @parentName IS NOT NULL RETURN dbo.ufnOldStleIsChildOf(@parentName, @required)
	
	RETURN NULL
END;
GO

DECLARE @parentID INTEGER
INSERT OldStyle(name) VALUES('0')
SELECT @parentID = dbo.ufnOldStleID('0')
INSERT OldStyle(name, parentID) VALUES('0.0', @parentID)
INSERT OldStyle(name, parentID) VALUES('0.1', @parentID)
SELECT @parentID = dbo.ufnOldStleID('0.0')
INSERT OldStyle(name, parentID) VALUES('0.0.0', @parentID)
INSERT OldStyle(name, parentID) VALUES('0.0.1', @parentID)
SELECT @parentID = dbo.ufnOldStleID('0.1')
INSERT OldStyle(name, parentID) VALUES('0.1.0', @parentID)
INSERT OldStyle(name, parentID) VALUES('0.1.1', @parentID)
INSERT OldStyle(name) VALUES('1')
SELECT @parentID = dbo.ufnOldStleID('1')
INSERT OldStyle(name, parentID) VALUES('1.0', @parentID)
INSERT OldStyle(name, parentID) VALUES('1.1', @parentID)
SELECT @parentID = dbo.ufnOldStleID('1.0')
INSERT OldStyle(name, parentID) VALUES('1.0.0', @parentID)
INSERT OldStyle(name, parentID) VALUES('1.0.1', @parentID)
SELECT @parentID = dbo.ufnOldStleID('1.1')
INSERT OldStyle(name, parentID) VALUES('1.1.0', @parentID)
INSERT OldStyle(name, parentID) VALUES('1.1.1', @parentID)
SELECT @parentID = dbo.ufnOldStleID('0.0.0')
INSERT OldStyle(name, parentID) VALUES('0.0.0.0', @parentID)
INSERT OldStyle(name, parentID) VALUES('0.0.0.1', @parentID)
SELECT @parentID = dbo.ufnOldStleID('0.0.1')
INSERT OldStyle(name, parentID) VALUES('0.0.1.0', @parentID)
INSERT OldStyle(name, parentID) VALUES('0.0.1.1', @parentID)
SELECT @parentID = dbo.ufnOldStleID('0.1.0')
INSERT OldStyle(name, parentID) VALUES('0.1.0.0', @parentID)
INSERT OldStyle(name, parentID) VALUES('0.1.0.1', @parentID)
SELECT @parentID = dbo.ufnOldStleID('0.1.1')
INSERT OldStyle(name, parentID) VALUES('0.1.1.0', @parentID)
INSERT OldStyle(name, parentID) VALUES('0.1.1.1', @parentID)
SELECT @parentID = dbo.ufnOldStleID('0.1.0.0')
INSERT OldStyle(name, parentID) VALUES('0.1.0.0.0', @parentID)
INSERT OldStyle(name, parentID) VALUES('0.1.0.0.1', @parentID)
SELECT @parentID = dbo.ufnOldStleID('0.1.1.0')
INSERT OldStyle(name, parentID) VALUES('0.1.1.0.0', @parentID)
INSERT OldStyle(name, parentID) VALUES('0.1.1.0.1', @parentID)
SELECT @parentID = dbo.ufnOldStleID('0.1.0.1')
INSERT OldStyle(name, parentID) VALUES('0.1.0.1.0', @parentID)
INSERT OldStyle(name, parentID) VALUES('0.1.0.1.1', @parentID)
SELECT @parentID = dbo.ufnOldStleID('1.0.1')
INSERT OldStyle(name, parentID) VALUES('1.0.1.0', @parentID)
INSERT OldStyle(name, parentID) VALUES('1.0.1.1', @parentID)
SELECT @parentID = dbo.ufnOldStleID('1.1.0')
INSERT OldStyle(name, parentID) VALUES('1.1.0.0', @parentID)
INSERT OldStyle(name, parentID) VALUES('1.1.0.1', @parentID)
SELECT @parentID = dbo.ufnOldStleID('1.1.1')
INSERT OldStyle(name, parentID) VALUES('1.1.1.0', @parentID)
INSERT OldStyle(name, parentID) VALUES('1.1.1.1', @parentID)
SELECT @parentID = dbo.ufnOldStleID('1.1.0.0')
INSERT OldStyle(name, parentID) VALUES('1.1.0.0.0', @parentID)
INSERT OldStyle(name, parentID) VALUES('1.1.0.0.1', @parentID)
SELECT @parentID = dbo.ufnOldStleID('1.1.1.0')
INSERT OldStyle(name, parentID) VALUES('1.1.1.0.0', @parentID)
INSERT OldStyle(name, parentID) VALUES('1.1.1.0.1', @parentID)
SELECT @parentID = dbo.ufnOldStleID('1.1.0.1')
INSERT OldStyle(name, parentID) VALUES('1.1.0.1.0', @parentID)
INSERT OldStyle(name, parentID) VALUES('1.1.0.1.1', @parentID)




