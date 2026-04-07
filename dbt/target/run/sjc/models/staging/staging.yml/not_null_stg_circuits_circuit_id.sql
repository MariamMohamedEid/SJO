
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select circuit_id
from "iceberg"."staging"."stg_circuits"
where circuit_id is null



  
  
      
    ) dbt_internal_test