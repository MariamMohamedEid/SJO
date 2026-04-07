
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select governorate_id
from "iceberg"."intermediate"."int_court_enriched"
where governorate_id is null



  
  
      
    ) dbt_internal_test