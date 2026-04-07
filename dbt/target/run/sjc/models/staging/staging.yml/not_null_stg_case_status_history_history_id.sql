
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select history_id
from "iceberg"."staging"."stg_case_status_history"
where history_id is null



  
  
      
    ) dbt_internal_test