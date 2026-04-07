
    
    

with all_values as (

    select
        court_level as value_field,
        count(*) as n_records

    from "iceberg"."staging"."stg_courts"
    group by court_level

)

select *
from all_values
where value_field not in (
    'Supreme','Appeal','First Instance'
)


