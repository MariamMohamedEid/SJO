
    
    

select
    status_key as unique_field,
    count(*) as n_records

from "iceberg"."marts"."dim_case_status"
where status_key is not null
group by status_key
having count(*) > 1


