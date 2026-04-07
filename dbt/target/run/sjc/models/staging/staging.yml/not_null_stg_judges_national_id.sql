
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select national_id
from "iceberg"."staging"."stg_judges"
where national_id is null



  
  
      
    ) dbt_internal_test