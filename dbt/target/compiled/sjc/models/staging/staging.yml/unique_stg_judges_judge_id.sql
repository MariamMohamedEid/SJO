
    
    

select
    judge_id as unique_field,
    count(*) as n_records

from "iceberg"."staging"."stg_judges"
where judge_id is not null
group by judge_id
having count(*) > 1


