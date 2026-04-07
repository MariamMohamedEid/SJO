
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select case_id
from "iceberg"."staging"."stg_case_status_history"
where case_id is null



  
  
      
    ) dbt_internal_test