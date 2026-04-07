
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select assignment_id
from "iceberg"."staging"."stg_judge_court_assignments"
where assignment_id is null



  
  
      
    ) dbt_internal_test