
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select circuit_id
from "iceberg"."intermediate"."int_case_enriched"
where circuit_id is null



  
  
      
    ) dbt_internal_test