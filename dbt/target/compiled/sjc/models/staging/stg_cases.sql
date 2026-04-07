-- ============================================================
-- models/staging/stg_cases.sql
-- ============================================================

with source as (
    select * from "hive"."landing"."cases"
),

typed as (
    select
        case_id,
        case_number,

        -- VARCHAR → INTEGER
        TRY_CAST(case_year AS INTEGER) as case_year,

        court_id,
        circuit_id,
        judge_id,
        status_id,

        -- Epoch → DATE
        CAST(from_unixtime(CAST(filing_date AS BIGINT) / 1000) AS DATE)           as filing_date,
        CAST(from_unixtime(CAST(first_hearing_date AS BIGINT) / 1000) AS DATE)    as first_hearing_date,
        CAST(from_unixtime(CAST(judgment_date AS BIGINT) / 1000) AS DATE)         as judgment_date,
        CAST(from_unixtime(CAST(closure_date AS BIGINT) / 1000) AS DATE)          as closure_date,

        -- Names
        plaintiff_name,
        plaintiff_name_en,
        defendant_name,
        defendant_name_en,

        -- Financials
        TRY_CAST(judicial_fees_amount AS DECIMAL(12,3)) as judicial_fees_amount,
        TRY_CAST(execution_revenue     AS DECIMAL(12,3)) as execution_revenue,
        TRY_CAST(claim_amount          AS DECIMAL(18,3)) as claim_amount,

        notes,

        -- Epoch → TIMESTAMP (IMPORTANT)
        CAST(from_unixtime(CAST(created_at AS BIGINT) / 1000) AS TIMESTAMP) as created_at,
        CAST(from_unixtime(CAST(updated_at AS BIGINT) / 1000) AS TIMESTAMP) as updated_at,

        current_timestamp as _loaded_at

    from source
)

select *
from typed