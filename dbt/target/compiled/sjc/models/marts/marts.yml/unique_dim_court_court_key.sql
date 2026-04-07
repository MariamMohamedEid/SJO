
    
    

select
    court_key as unique_field,
    count(*) as n_records

from "iceberg"."marts"."dim_court"
where court_key is not null
group by court_key
having count(*) > 1


