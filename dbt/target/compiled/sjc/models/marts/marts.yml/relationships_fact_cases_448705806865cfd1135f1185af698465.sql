
    
    

with child as (
    select filing_date_key as from_field
    from "iceberg"."marts"."fact_cases"
    where filing_date_key is not null
),

parent as (
    select date_key as to_field
    from "iceberg"."marts"."dim_date"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


