
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select judge_id
from "iceberg"."marts"."dim_judge"
where judge_id is null



  
  
      
    ) dbt_internal_test