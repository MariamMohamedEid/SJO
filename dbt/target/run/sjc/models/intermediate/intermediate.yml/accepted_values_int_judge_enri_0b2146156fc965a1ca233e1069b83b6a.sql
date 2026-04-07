
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        court_level as value_field,
        count(*) as n_records

    from "iceberg"."intermediate"."int_judge_enriched"
    group by court_level

)

select *
from all_values
where value_field not in (
    'Supreme','Appeal','First Instance'
)



  
  
      
    ) dbt_internal_test