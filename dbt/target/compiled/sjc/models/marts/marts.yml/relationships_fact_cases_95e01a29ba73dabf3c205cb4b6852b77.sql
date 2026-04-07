
    
    

with child as (
    select circuit_key as from_field
    from "iceberg"."marts"."fact_cases"
    where circuit_key is not null
),

parent as (
    select circuit_key as to_field
    from "iceberg"."marts"."dim_circuit"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


