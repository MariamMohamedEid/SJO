
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select hearing_id
from "iceberg"."staging"."stg_hearings"
where hearing_id is null



  
  
      
    ) dbt_internal_test