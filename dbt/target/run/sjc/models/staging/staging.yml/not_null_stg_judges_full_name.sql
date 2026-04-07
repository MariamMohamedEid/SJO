
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select full_name
from "iceberg"."staging"."stg_judges"
where full_name is null



  
  
      
    ) dbt_internal_test