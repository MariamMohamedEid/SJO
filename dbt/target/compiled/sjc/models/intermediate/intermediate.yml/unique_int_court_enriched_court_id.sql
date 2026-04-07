
    
    

select
    court_id as unique_field,
    count(*) as n_records

from "iceberg"."intermediate"."int_court_enriched"
where court_id is not null
group by court_id
having count(*) > 1


