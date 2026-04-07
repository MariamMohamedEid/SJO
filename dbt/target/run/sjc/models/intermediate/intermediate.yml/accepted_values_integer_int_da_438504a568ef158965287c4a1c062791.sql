
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  

select day_of_week
from "iceberg"."intermediate"."int_date_spine"
where day_of_week not in (
    1, 2, 3, 4, 5, 6, 7
)


  
  
      
    ) dbt_internal_test