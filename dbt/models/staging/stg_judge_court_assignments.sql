with source as (

    select *
    from {{ source('sjc_source', 'judge_court_assignments') }}

),

typed as (

    select
        assignment_id,
        judge_id,
        court_id,
        circuit_id,
        CAST(from_unixtime(CAST(assigned_from AS BIGINT) / 1000) AS DATE) as assigned_from,
        CAST(from_unixtime(CAST(assigned_to AS BIGINT) / 1000) AS DATE) as assigned_to,
        role,
        current_timestamp as _loaded_at

    from source

)

select *
from typed