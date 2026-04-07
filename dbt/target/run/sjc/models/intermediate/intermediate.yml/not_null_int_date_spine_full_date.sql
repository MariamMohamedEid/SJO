
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select full_date
from "iceberg"."intermediate"."int_date_spine"
where full_date is null



  
  
      
    ) dbt_internal_test