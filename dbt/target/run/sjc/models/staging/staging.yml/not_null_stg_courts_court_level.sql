
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select court_level
from "iceberg"."staging"."stg_courts"
where court_level is null



  
  
      
    ) dbt_internal_test