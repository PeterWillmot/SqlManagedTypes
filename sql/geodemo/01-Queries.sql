USE GeoDemo
GO

DECLARE @ptArrival GEOGRAPHY
		, @ptHotel GEOGRAPHY
		, @ptVenue GEOGRAPHY
		,@lnTaxi GEOGRAPHY
		,@lnWalk GEOGRAPHY
		,@arBoundary GEOGRAPHY
		,@arAirport GEOGRAPHY
		,@arPark GEOGRAPHY

SELECT @arBoundary = geo FROM MyGeo WHERE type = 'area' AND name = 'boundary'
SELECT @arPark = geo FROM MyGeo WHERE type = 'area' AND name = 'airport'
SELECT @arAirport = geo FROM MyGeo WHERE type = 'area' AND name = 'park'

SELECT @ptArrival = geo FROM MyGeo WHERE type = 'place' AND name = 'arrival'
SELECT @ptHotel = geo FROM MyGeo WHERE type = 'place' AND name = 'hotel'
SELECT @ptVenue = geo FROM MyGeo WHERE type = 'place' AND name = 'venue'

SELECT @lnTaxi = geo FROM MyGeo WHERE type = 'journey' AND name = 'taxi'
SELECT @lnWalk = geo FROM MyGeo WHERE type = 'journey' AND name = 'walk'

SELECT 'Linear distance Arrival to Hotel: ' + CAST(CAST((@ptArrival.STDistance(@ptHotel) / 1000) AS DECIMAL(10,2)) AS VARCHAR(MAX)) + ' km'
SELECT 'Journey distance Arrival to Hotel: ' + CAST(CAST((@lnTaxi.STLength() / 1000) AS DECIMAL(10,2)) AS VARCHAR(MAX)) + ' km'
SELECT 'Linear distance Hotel to Venue: ' + CAST(CAST((@ptHotel.STDistance(@ptVenue) / 1000) AS DECIMAL(10,2)) AS VARCHAR(MAX)) + ' km'
SELECT 'Journey distance Hotel to Venue: ' + CAST(CAST((@lnWalk.STLength() / 1000) AS DECIMAL(10,2)) AS VARCHAR(MAX)) + ' km'

SELECT 'Boundary perimiter is : ' + CAST(CAST((@arBoundary.STLength() / 1000) AS DECIMAL(10,2)) AS VARCHAR(MAX)) + ' km long'
SELECT 'Park perimiter is : ' + CAST(CAST((@arPark.STLength() / 1000) AS DECIMAL(10,2)) AS VARCHAR(MAX)) + ' km long'

IF @arBoundary.MakeValid().STContains(@ptArrival) = 1
	SELECT 'The boundary area contains the point of arrival'
ELSE
	SELECT 'The boundary area does not contain the point of arrival'

IF @arBoundary.MakeValid().STContains(@ptHotel) = 1
	SELECT 'The boundary area contains the hotel'
ELSE
	SELECT 'The boundary area does not contain the hotel'


