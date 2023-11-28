With count_dup as(
	select 
		*, 
		row_number() OVER(partition by user_id order by user_id) as row_number
	from dataset2 

),

dup_id AS
(
	select distinct(user_id) 
	from count_dup 
	where row_number > 1
)

select * 
from dataset2 
where user_id in (select * from dup_id ) 
order by 1


