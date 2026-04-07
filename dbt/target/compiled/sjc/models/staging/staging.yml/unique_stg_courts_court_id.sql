
    
    

select
    court_id as unique_field,
    count(*) as n_records

from "iceberg"."staging"."stg_courts"
where court_id is not null
group by court_id
having count(*) > 1


