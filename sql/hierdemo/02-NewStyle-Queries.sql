USE HierDemo
GO

SELECT regionID, name, hier
FROM Region

DECLARE @parent HIERARCHYID
		,@child1 HIERARCHYID
		,@child2 HIERARCHYID
		,@child3 HIERARCHYID

SELECT @parent = hier FROM Region WHERE name = 'South Africa'
SELECT @child1 = hier FROM Region WHERE name = 'City of Cape Town'
SELECT @child2 = hier FROM Region WHERE name = 'Western Cape'
SELECT @child3 = hier FROM Region WHERE name = 'KwaZulu Natal'

SELECT name FROM Region WHERE hier =  @child1.GetAncestor(2)

SELECT @Child1.IsDescendantOf(@parent)
SELECT @Child1.IsDescendantOf(@child1)

