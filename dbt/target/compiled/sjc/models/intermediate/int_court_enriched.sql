-- ============================================================
-- models/intermediate/int_court_enriched.sql
-- ============================================================

with courts as (
    select * from "iceberg"."staging"."stg_courts"
),

wilayat as (
    select * from "iceberg"."staging"."wilayat"
),

governorates as (
    select * from "iceberg"."staging"."governorates"
)

select
    co.court_id,
    co.court_name,
    co.court_name_en,
    co.court_level,
    co.panel_size,

    w.wilayat_id,
    w.wilayat_name,
    w.wilayat_name_en,

    g.governorate_id,
    g.governorate_name,
    g.governorate_name_en,
    g.governorate_code

from courts co
left join wilayat w
    on co.wilayat_id = w.wilayat_id
inner join governorates g
    on co.governorate_id = g.governorate_id