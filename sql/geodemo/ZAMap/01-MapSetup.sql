/*
-- Last edit 2017/03/12
-- For illustatrive purposes only, not recommended for production use
-- (c) QRI (Pty) Ltd, 2017
*/

USE Master
GO

IF NOT EXISTS(SELECT 1 FROM sys.databases WHERE name = 'GeoDemo') CREATE DATABASE GeoDemo
GO

USE GeoDemo
GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE name = 'Region') DROP TABLE Region
GO
IF EXISTS(SELECT 1 FROM sys.objects WHERE name = 'RegionType') DROP TABLE RegionType
GO

CREATE TABLE RegionType
(
	typeID INTEGER IDENTITY PRIMARY KEY
	,name VARCHAR(200) NOT NULL
)
GO

CREATE UNIQUE NONCLUSTERED INDEX NC_RegionType_Name on RegionType(name)
GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE name = 'ufnGetRegionTypeID') DROP FUNCTION dbo.ufnGetRegionTypeID
GO

CREATE FUNCTION ufnGetRegionTypeID( @typeName VARCHAR(200))
RETURNS INTEGER
AS
BEGIN
	RETURN ISNULL((SELECT typeID FROM RegionType WHERE name = @typeName), 0)
END;
GO

IF dbo.ufnGetRegionTypeID('Country') <= 0 INSERT RegionType(name) VALUES('Country')
IF dbo.ufnGetRegionTypeID('Province') <= 0 INSERT RegionType(name) VALUES('Province')
IF dbo.ufnGetRegionTypeID('District') <= 0 INSERT RegionType(name) VALUES('District')
IF dbo.ufnGetRegionTypeID('Municipality') <= 0 INSERT RegionType(name) VALUES('Municipality')

CREATE TABLE Region
(
	regionID INTEGER IDENTITY PRIMARY KEY NONCLUSTERED
	,typeID INTEGER NOT NULL FOREIGN KEY REFERENCES RegionType(typeID)
	,name VARCHAR(200) NOT NULL
	,geo GEOGRAPHY
	,parentID INTEGER FOREIGN KEY REFERENCES Region(regionID)
)
GO

CREATE UNIQUE CLUSTERED INDEX CL_Region ON Region(typeID, name)
GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE name = 'ufnGetRegionIDForParentAndTypeAndName') DROP FUNCTION dbo.ufnGetRegionIDForParentAndTypeAndName
GO

CREATE FUNCTION ufnGetRegionIDForParentAndTypeAndName( @parentID INTEGER, @typeName VARCHAR(200), @regionName VARCHAR(200))
RETURNS INTEGER
AS
BEGIN
	RETURN ISNULL((SELECT regionID FROM Region WHERE (parentID IS NULL OR parentID = @parentID) AND typeID = dbo.ufnGetRegionTypeID(@typeName) AND name = @regionName), 0)
END;
GO

DELETE FROM Region

INSERT Region(typeID, name, geo) 
SELECT dbo.ufnGetRegionTypeID('Country'), 'South Africa', NULL

INSERT Region(typeID, name, geo, parentID)
SELECT dbo.ufnGetRegionTypeID('Province') as typeID
		, st.itemName AS name
		, st.geoObjectText AS geo
		, dbo.ufnGetRegionIDForParentAndTypeAndName(NULL, 'Country', 'South Africa') as parentID
FROM QRIGeoSpatialInfoSource.dbo.ZAMap st
WHERE st.itemType = 'Province' AND NOT EXISTS(SELECT 1 FROM Region r WHERE r.parentID = dbo.ufnGetRegionIDForParentAndTypeAndName(NULL, 'Country', 'South Africa') AND r.name = st.itemName)

INSERT Region(typeID, name, geo, parentID)
SELECT dbo.ufnGetRegionTypeID('District') as typeID
		, st.itemName AS name
		, st.geoObjectText AS geo
		, dbo.ufnGetRegionIDForParentAndTypeAndName(dbo.ufnGetRegionIDForParentAndTypeAndName(NULL, 'Country', 'South Africa') , 'Province', st.parentName) as parentID
FROM QRIGeoSpatialInfoSource.dbo.ZAMap st
WHERE st.itemType = 'District' AND NOT EXISTS(SELECT 1 FROM Region r WHERE r.parentID = dbo.ufnGetRegionIDForParentAndTypeAndName(dbo.ufnGetRegionIDForParentAndTypeAndName(NULL, 'Country', 'South Africa') , 'Province', st.parentName) AND r.name = st.itemName)

/*
SELECT r.name
FROM Region r
	JOIN RegionType t ON t.typeID = r.typeID
WHERE t.name = 'province'
*/