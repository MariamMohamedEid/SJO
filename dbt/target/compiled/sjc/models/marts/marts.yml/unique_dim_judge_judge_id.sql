
    
    

select
    judge_id as unique_field,
    count(*) as n_records

from "iceberg"."marts"."dim_judge"
where judge_id is not null
group by judge_id
having count(*) > 1


