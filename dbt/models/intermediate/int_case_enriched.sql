-- ============================================================
-- models/intermediate/int_case_enriched.sql
-- ============================================================

with cases as (
    select * from {{ ref('stg_cases') }}
),

circuits as (
    select * from {{ ref('stg_circuits') }}
),

courts as (
    select * from {{ ref('stg_courts') }}
),

judges as (
    select * from {{ ref('stg_judges') }}
),

statuses as (
    select * from {{ ref('case_statuses') }}
),

sla_targets as (
    select *
    from (values
        ('Civil',           365),
        ('Criminal',        180),
        ('Commercial',      270),
        ('Labour',          120),
        ('Personal Status', 365),
        ('Rental',          180),
        ('Tax',             365),
        ('Juvenile',         90),
        ('Blood Money',     365),
        ('Administrative',  365)
    ) as t(case_category, target_days)
)
select
    c.case_number,
    c.case_year,
    c.court_id,
    c.circuit_id,
    c.judge_id,
    c.status_id,

    co.court_level,
    ci.case_category,
    ci.panel_type,
    ci.panel_type_en,
    j.court_level as judge_court_level,
    s.status_code,
    s.status_category,
    -- DATE KEYS (YYYYMMDD)
    CAST(date_format(c.filing_date, '%Y%m%d') AS INTEGER)        as filing_date_key,
    CAST(date_format(c.first_hearing_date, '%Y%m%d') AS INTEGER) as first_hearing_date_key,
    CAST(date_format(c.judgment_date, '%Y%m%d') AS INTEGER)      as judgment_date_key,
    CAST(date_format(c.closure_date, '%Y%m%d') AS INTEGER)       as closure_date_key,

    c.filing_date,
    c.first_hearing_date,
    c.judgment_date,
    c.closure_date,
    -- DURATION MEASURES
    date_diff('day', c.filing_date, c.closure_date)          as case_duration_days,
    date_diff('day', c.filing_date, c.first_hearing_date)    as days_to_first_hearing,
    -- SLA FLAG
    case
        when c.closure_date is null then null
        when date_diff('day', c.filing_date, c.closure_date) > sla.target_days then true
        else false
    end as is_sla_breached,
    sla.target_days as sla_target_days,
    -- FINANCIALS
    c.judicial_fees_amount,
    c.execution_revenue,
    c.claim_amount,
    -- PARTY INFO
    c.plaintiff_name,
    c.plaintiff_name_en,
    c.defendant_name,
    c.defendant_name_en,

    current_timestamp as _loaded_at

from cases c
inner join circuits ci   on c.circuit_id  = ci.circuit_id
inner join courts   co   on c.court_id    = co.court_id
left  join judges   j    on c.judge_id    = j.judge_id
inner join statuses s    on c.status_id   = s.status_id
left  join sla_targets sla on ci.case_category = sla.case_category