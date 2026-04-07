
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select governorate_code
from "iceberg"."intermediate"."int_court_enriched"
where governorate_code is null



  
  
      
    ) dbt_internal_test