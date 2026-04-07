
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select hearing_date
from "iceberg"."staging"."stg_hearings"
where hearing_date is null



  
  
      
    ) dbt_internal_test