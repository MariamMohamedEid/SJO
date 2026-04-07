
    
    

select
    hearing_id as unique_field,
    count(*) as n_records

from "iceberg"."staging"."stg_hearings"
where hearing_id is not null
group by hearing_id
having count(*) > 1


