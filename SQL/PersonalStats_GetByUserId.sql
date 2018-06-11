USE [C54_RecruitHub]
GO
/****** Object:  StoredProcedure [dbo].[PersonalStats_GetByUserId]    Script Date: 6/10/2018 7:28:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[PersonalStats_GetByUserId]
@UserId INT
AS 
/*
DECLARE @UserId INT = 223
EXEC PersonalStats_GetByUserId
@UserId 
*/

BEGIN
	SELECT 
		u.Id as UserId,
		u.UserTypeId,
		p.Id,
		p.StatsJson,
		p.DateCreated,
		p.DateModified
	FROM
		PersonalStats p
	INNER JOIN Users u
		ON u.Id = JSON_VALUE(p.StatsJson, '$.UserId')
	WHERE JSON_VALUE(p.StatsJson, '$.UserId') = @UserId 
END