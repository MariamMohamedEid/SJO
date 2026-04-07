
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  

select year
from "iceberg"."intermediate"."int_date_spine"
where year not in (
    2020, 2021, 2022, 2023, 2024, 2025, 2026, 2027, 2028, 2029, 2030
)


  
  
      
    ) dbt_internal_test