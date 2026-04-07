
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select changed_at
from "iceberg"."staging"."stg_case_status_history"
where changed_at is null



  
  
      
    ) dbt_internal_test