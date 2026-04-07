
    
    

select
    assignment_id as unique_field,
    count(*) as n_records

from "iceberg"."staging"."stg_judge_court_assignments"
where assignment_id is not null
group by assignment_id
having count(*) > 1


