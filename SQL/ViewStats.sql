
ALTER PROC [dbo].[MyProfileStats_GetAllViewsByUserId]
@Owner_UserId INT
AS
/*
DECLARE @Owner_UserId INT = 28
EXEC MyProfileStats_GetAllViewsByUserId
@Owner_UserId
*/
BEGIN
	/*Lastest Views from*/
	SELECT TOP 3 
		u.Id as UserId, 
		u.FullName,
		a.DateCreated, 
		a.DateModified
	FROM Analytics a
		INNER JOIN Users u 
			ON u.Id = JSON_VALUE(a.Data, '$.UserId')
	WHERE JSON_VALUE(a.Data, '$.Owner_UserId') = @Owner_UserId
		AND JSON_VALUE(a.Data, '$.Action') = 'View'
		AND JSON_VALUE(a.Data, '$.Category') ='Profile'
	ORDER BY DateCreated DESC

	/*View Count*/
	SELECT 
		Data,
		DateCreated,
		DateModified
	FROM Analytics 
	WHERE DateCreated >=DATEADD(month,-12,DATEADD(day,DATEDIFF(day,0,GETDATE()),0)) 
		AND DateCreated <=DATEADD(day,DATEDIFF(day,0,GETDATE()),0)
		AND JSON_VALUE(Data, '$.Owner_UserId') = @Owner_UserId
		AND JSON_VALUE(Data, '$.Action') = 'View'
		AND JSON_VALUE(Data, '$.Category') ='Profile'
		
	ORDER BY DateCreated ASC

	/*Most Views From:*/
	SELECT TOP 3 
		COUNT(JSON_VALUE(a.Data, '$.UserId')) as ViewCount,
		u.Id as UserId,
		u.FullName
	FROM Analytics a 
		INNER JOIN Users u
			ON u.Id = JSON_VALUE(a.Data, '$.UserId')
	WHERE JSON_VALUE(a.Data, '$.Owner_UserId') = @Owner_UserId
		AND JSON_VALUE(a.Data, '$.Action') = 'View'
		AND JSON_VALUE(a.Data, '$.Category') ='Profile'
	GROUP BY u.Id, u.FullName
	ORDER BY COUNT(JSON_VALUE(Data, '$.UserId')) DESC

END