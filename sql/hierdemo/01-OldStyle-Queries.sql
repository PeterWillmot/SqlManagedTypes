USE hierDemo
GO

SELECT A.id, A.name, A.parentID, B.id, B.name, B.parentID
FROM OldStyle A
	JOIN OldStyle B ON A.id = B.parentID

DECLARE @name VARCHAR(1000) = '0.0.1.0'
		,@requiredParent VARCHAR(1000) = '0'

SELECT dbo.ufnOldStleParentName(@name)

SELECT dbo.ufnOldStleParentName(dbo.ufnOldStleParentName(@name))

SELECT dbo.ufnOldStleParentName(dbo.ufnOldStleParentName(dbo.ufnOldStleParentName(@name)))

SELECT dbo.ufnOldStleParentName(dbo.ufnOldStleParentName(dbo.ufnOldStleParentName(dbo.ufnOldStleParentName(@name))))

SELECT dbo.ufnOldStleIsChildOf(@name, @requiredParent)