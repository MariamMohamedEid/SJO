
    
    

select
    judge_key as unique_field,
    count(*) as n_records

from "iceberg"."marts"."dim_judge"
where judge_key is not null
group by judge_key
having count(*) > 1


