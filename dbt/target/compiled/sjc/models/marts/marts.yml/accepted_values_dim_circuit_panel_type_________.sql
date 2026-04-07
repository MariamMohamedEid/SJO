
    
    

with all_values as (

    select
        panel_type as value_field,
        count(*) as n_records

    from "iceberg"."marts"."dim_circuit"
    group by panel_type

)

select *
from all_values
where value_field not in (
    'فردي','ثلاثي','خماسي'
)


