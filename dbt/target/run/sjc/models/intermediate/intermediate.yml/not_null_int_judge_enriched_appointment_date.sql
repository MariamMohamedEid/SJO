
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select appointment_date
from "iceberg"."intermediate"."int_judge_enriched"
where appointment_date is null



  
  
      
    ) dbt_internal_test