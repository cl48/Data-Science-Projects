--SELECT COUNT(DISTINCT user_id) from dataset1 
-- 48,885 unique out of 49,799


-- Reach formula over time
/*
SELECT date, COUNT(user_id) From dataset1
group by date
order by date
*/


-- Frequency formula
/*
SELECT 
	date, 
	SUM(impressions) total_impressions, 
	COUNT(DISTINCT user_id) as total_reach,
	SUM(clicks)/ SUM(impressions) as CTR,
	SUM(video_midpoint + video_complete_views) / SUM(impressions) as VTR,
	SUM(conversions)/ SUM(impressions) as CR
FROM
	dataset1
GROUP BY
	1
ORDER BY
	1;
*/


WITH totals as
(
SELECT 
	--date, 
	asset,
	COUNT(DISTINCT user_id) as total_reach,
	SUM(clicks) as total_clicks, 
	SUM(impressions) as total_impressions, 
	SUM(video_midpoint) as total_video_midpoint, 
	SUM(video_complete_views) as total_video_complete_views,
	SUM(conversions) as total_conversions
from dataset1
group by asset
order by asset
),
metrics as
(
SELECT 
	--date,
	asset,
	total_reach,
	ROUND((total_impressions * 1.0) /total_reach, 2) as Frequency,
	ROUND(((total_clicks * 1.0) /total_impressions) * 100, 2)  as CTR,
	ROUND((((total_video_midpoint + total_video_complete_views) * 1.0) / total_impressions) * 100, 2) as VTR,
	ROUND(((total_conversions * 1.0)/total_impressions) * 100, 2) as CR
from totals 
),

calc_total_reach as
(
SELECT
	SUM(total_reach) as sum_total_reach
FROM
	totals

)

SELECT 
	*, 
	round((total_reach/(SELECT sum_total_reach from calc_total_reach)),2) as reach_percent,
	round((total_reach/(SELECT sum_total_reach from calc_total_reach))*0.2 + Frequency*0.2 + CTR*0.2 + VTR*0.2 + CR*0.2, 2) as asset_weighted_avg 
from metrics 

/*
SELECT
	corr(CR, total_reach) as corr_Reach_CR,
	corr(CR,Frequency) as corr_Freq_CR, 
	corr(CR,CTR) as cor_CTR_CR, 
	corr(CR,VTR) as corr_VTR_CR,
	corr(VTR, total_reach) as corr_Reach_VTR,
	corr(VTR, Frequency) as corr_Freq_VTR,
	corr(VTR, CTR) as corr_CTR_VTR	
	
from metrics
*/
/*
SELECT
	date,
	round((total_conversions * 1.0/unique_id), 5) as per_conv_uniq,
	round((total_conversions * 1.0/total_count), 5) as per_conv_total
FROM (
SELECT
	date,
	COUNT(DISTINCT user_id) as unique_id,
	COUNT(*) as total_count,
	sum(conversions) as total_conversions
from
	dataset1
GROUP BY date
ORDER BY date
) as base;

*/








