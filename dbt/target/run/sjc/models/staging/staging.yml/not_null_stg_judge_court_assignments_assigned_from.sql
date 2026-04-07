
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select assigned_from
from "iceberg"."staging"."stg_judge_court_assignments"
where assigned_from is null



  
  
      
    ) dbt_internal_test