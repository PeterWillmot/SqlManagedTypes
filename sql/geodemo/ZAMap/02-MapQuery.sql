SELECT r.name --, r.geo 
FROM Region r
	JOIN RegionType rt ON rt.typeID = r.typeID
WHERE rt.name = 'Province'