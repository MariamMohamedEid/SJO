
    
    

with all_values as (

    select
        court_level as value_field,
        count(*) as n_records

    from "iceberg"."marts"."dim_court"
    group by court_level

)

select *
from all_values
where value_field not in (
    'Supreme','Appeal','First Instance'
)


