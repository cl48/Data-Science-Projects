
SELECT 
	asset,
	device_type,
	os,
	gender,
	avg(age) as average_age,
	COUNT(os) as count
from 
	dataset1 INNER JOIN dataset2 ON dataset1.user_id = dataset2.user_id
where
	device_type is not null and os is not null and gender is not null
GROUP BY
	asset,
	device_type,
	os,
	gender
ORDER BY asset, device_type, os, gender




