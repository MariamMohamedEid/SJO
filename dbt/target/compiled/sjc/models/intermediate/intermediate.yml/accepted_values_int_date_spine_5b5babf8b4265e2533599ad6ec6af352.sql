
    
    

with all_values as (

    select
        year as value_field,
        count(*) as n_records

    from "iceberg"."intermediate"."int_date_spine"
    group by year

)

select *
from all_values
where value_field not in (
    '2020','2021','2022','2023','2024','2025','2026','2027','2028','2029','2030'
)


