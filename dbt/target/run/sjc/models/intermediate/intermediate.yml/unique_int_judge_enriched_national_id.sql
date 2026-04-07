
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    national_id as unique_field,
    count(*) as n_records

from "iceberg"."intermediate"."int_judge_enriched"
where national_id is not null
group by national_id
having count(*) > 1



  
  
      
    ) dbt_internal_test