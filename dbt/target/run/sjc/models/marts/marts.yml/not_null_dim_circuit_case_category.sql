
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select case_category
from "iceberg"."marts"."dim_circuit"
where case_category is null



  
  
      
    ) dbt_internal_test