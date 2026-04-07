
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select sla_target_days
from "iceberg"."intermediate"."int_case_enriched"
where sla_target_days is null



  
  
      
    ) dbt_internal_test