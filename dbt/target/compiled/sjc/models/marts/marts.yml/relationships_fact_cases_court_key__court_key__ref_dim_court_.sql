
    
    

with child as (
    select court_key as from_field
    from "iceberg"."marts"."fact_cases"
    where court_key is not null
),

parent as (
    select court_key as to_field
    from "iceberg"."marts"."dim_court"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


