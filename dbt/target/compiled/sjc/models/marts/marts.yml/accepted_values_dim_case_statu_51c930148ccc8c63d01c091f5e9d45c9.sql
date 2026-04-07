
    
    

with all_values as (

    select
        status_category as value_field,
        count(*) as n_records

    from "iceberg"."marts"."dim_case_status"
    group by status_category

)

select *
from all_values
where value_field not in (
    'Active','Suspended','Closed'
)


