-- ============================================================
-- models/intermediate/int_date_spine.sql
-- ============================================================

with spine as (
    select date_day
    from unnest(
        sequence(
            date '2020-01-01',
            date '2030-12-31',
            interval '1' day
        )
    ) as t(date_day)
),
dates as (
    select cast(date_day as date) as full_date
    from spine
)
select
    -- Surrogate key YYYYMMDD
    cast(date_format(full_date, '%Y%m%d') as integer)       as date_key,
    full_date,
    -- Day
    cast(extract(day from full_date) as integer)            as day,
    cast(day_of_week(full_date) as integer)                 as day_of_week,
    format_datetime(full_date, 'EEEE')                      as day_name,
    -- Week
    cast(extract(week from full_date) as integer)           as week,
    -- Month
    cast(extract(month from full_date) as integer)          as month,
    format_datetime(full_date, 'MMMM')                      as month_name,
    -- Quarter / Year
    cast(extract(quarter from full_date) as integer)        as quarter,
    cast(extract(year from full_date) as integer)           as year,
    -- Weekend (Oman: Friday=5, Saturday=6)
    case
        when day_of_week(full_date) in (5, 6) then true
        else false
    end                                                      as is_weekend,
    false                                                    as is_holiday,
    cast(null as integer)                                    as hijri_year

from dates