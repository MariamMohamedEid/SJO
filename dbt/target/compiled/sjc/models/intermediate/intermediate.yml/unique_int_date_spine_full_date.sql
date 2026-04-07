
    
    

select
    full_date as unique_field,
    count(*) as n_records

from "iceberg"."intermediate"."int_date_spine"
where full_date is not null
group by full_date
having count(*) > 1


