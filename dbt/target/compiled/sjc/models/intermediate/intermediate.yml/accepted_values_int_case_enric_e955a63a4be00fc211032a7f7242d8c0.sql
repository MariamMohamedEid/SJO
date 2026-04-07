
    
    

with all_values as (

    select
        status_category as value_field,
        count(*) as n_records

    from "iceberg"."intermediate"."int_case_enriched"
    group by status_category

)

select *
from all_values
where value_field not in (
    'Active','Suspended','Closed'
)


