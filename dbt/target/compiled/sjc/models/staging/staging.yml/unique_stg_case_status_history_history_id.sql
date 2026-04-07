
    
    

select
    history_id as unique_field,
    count(*) as n_records

from "iceberg"."staging"."stg_case_status_history"
where history_id is not null
group by history_id
having count(*) > 1


