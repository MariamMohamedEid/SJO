
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select status_category
from "iceberg"."intermediate"."int_case_enriched"
where status_category is null



  
  
      
    ) dbt_internal_test