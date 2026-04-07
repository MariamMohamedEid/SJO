
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select national_id
from "iceberg"."intermediate"."int_judge_enriched"
where national_id is null



  
  
      
    ) dbt_internal_test