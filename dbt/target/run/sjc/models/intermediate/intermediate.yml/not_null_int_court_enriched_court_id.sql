
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select court_id
from "iceberg"."intermediate"."int_court_enriched"
where court_id is null



  
  
      
    ) dbt_internal_test