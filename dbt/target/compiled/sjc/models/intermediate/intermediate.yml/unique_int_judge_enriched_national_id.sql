
    
    

select
    national_id as unique_field,
    count(*) as n_records

from "iceberg"."intermediate"."int_judge_enriched"
where national_id is not null
group by national_id
having count(*) > 1


