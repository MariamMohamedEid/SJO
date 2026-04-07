
    
    

select
    case_number as unique_field,
    count(*) as n_records

from "iceberg"."staging"."stg_cases"
where case_number is not null
group by case_number
having count(*) > 1


