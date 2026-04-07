
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  

select quarter
from "iceberg"."intermediate"."int_date_spine"
where quarter not in (
    1, 2, 3, 4
)


  
  
      
    ) dbt_internal_test