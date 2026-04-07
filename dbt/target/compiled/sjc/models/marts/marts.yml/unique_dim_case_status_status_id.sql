
    
    

select
    status_id as unique_field,
    count(*) as n_records

from "iceberg"."marts"."dim_case_status"
where status_id is not null
group by status_id
having count(*) > 1


