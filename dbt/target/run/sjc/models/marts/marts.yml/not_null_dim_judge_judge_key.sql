
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select judge_key
from "iceberg"."marts"."dim_judge"
where judge_key is null



  
  
      
    ) dbt_internal_test