
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select case_number
from "iceberg"."staging"."stg_cases"
where case_number is null



  
  
      
    ) dbt_internal_test