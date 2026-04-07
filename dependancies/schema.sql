CREATE SCHEMA IF NOT EXISTS hive.landing
WITH (location = 's3a://hive');

CREATE TABLE hive.landing.governorates (
    governorate_id      INTEGER,
    governorate_name    VARCHAR,
    governorate_name_en VARCHAR,
    governorate_code    VARCHAR
)
WITH (
    external_location = 's3a://hive/governorates/',
    format = 'PARQUET'
);

CREATE TABLE hive.landing.wilayat (
    wilayat_id      INTEGER,
    wilayat_name    VARCHAR,
    wilayat_name_en VARCHAR,
    governorate_id  INTEGER
)
WITH (
    external_location = 's3a://hive/wilayat/',
    format = 'PARQUET'
);

CREATE TABLE hive.landing.courts (
    court_id        INTEGER,
    court_name      VARCHAR,
    court_name_en   VARCHAR,
    court_level     VARCHAR,
    wilayat_id      INTEGER,
    governorate_id  INTEGER,
    panel_size      SMALLINT
)
WITH (
    external_location = 's3a://hive/courts/',
    format = 'PARQUET'
);

CREATE TABLE hive.landing.circuits (
    circuit_id      INTEGER,
    court_id        INTEGER,
    circuit_name    VARCHAR,
    circuit_name_en VARCHAR,
    panel_type      VARCHAR,
    panel_type_en   VARCHAR,
    case_category   VARCHAR
)
WITH (
    external_location = 's3a://hive/circuits/',
    format = 'PARQUET'
);

CREATE TABLE hive.landing.judges (
    judge_id           INTEGER,
    national_id        VARCHAR,
    first_name         VARCHAR,
    last_name          VARCHAR,
    full_name          VARCHAR,
    first_name_en      VARCHAR,
    last_name_en       VARCHAR,
    full_name_en       VARCHAR,
    appointment_date   VARCHAR,
    rank               VARCHAR,
    rank_en            VARCHAR,
    specialization     VARCHAR,
    specialization_en  VARCHAR,
    court_level        VARCHAR,
    created_at         VARCHAR,
    updated_at         VARCHAR
)
WITH (
    external_location = 's3a://hive/judges/',
    format = 'PARQUET'
);

CREATE TABLE hive.landing.case_statuses (
    status_id       INTEGER,
    status_code     VARCHAR,
    status_name     VARCHAR,
    status_name_en  VARCHAR,
    status_category VARCHAR,
    is_terminal     BOOLEAN
)
WITH (
    external_location = 's3a://hive/case_statuses/',
    format = 'PARQUET'
);

CREATE TABLE hive.landing.cases (
    case_id               INTEGER,
    case_number           VARCHAR,
    case_year             SMALLINT,
    court_id              INTEGER,
    circuit_id            INTEGER,
    judge_id              INTEGER,
    status_id             INTEGER,
    filing_date           DATE,
    first_hearing_date    DATE,
    judgment_date         DATE,
    closure_date          DATE,
    plaintiff_name        VARCHAR,
    plaintiff_name_en     VARCHAR,
    defendant_name        VARCHAR,
    defendant_name_en     VARCHAR,
    judicial_fees_amount  DECIMAL(12,3),
    execution_revenue     DECIMAL(12,3),
    claim_amount          DECIMAL(18,3),
    notes                 VARCHAR,
    created_at            TIMESTAMP,
    updated_at            TIMESTAMP
)
WITH (
    external_location = 's3a://hive/cases/',
    format = 'PARQUET'
);

CREATE TABLE hive.landing.hearings (
    hearing_id        INTEGER,
    case_id           INTEGER,
    hearing_date      DATE,
    hearing_type      VARCHAR,
    hearing_type_en   VARCHAR,
    judge_id          INTEGER,
    outcome           VARCHAR,
    outcome_en        VARCHAR,
    next_hearing_date DATE
)
WITH (
    external_location = 's3a://hive/hearings/',
    format = 'PARQUET'
);

CREATE TABLE hive.landing.case_status_history (
    history_id  INTEGER,
    case_id     INTEGER,
    status_id   INTEGER,
    changed_at  TIMESTAMP,
    changed_by  VARCHAR
)
WITH (
    external_location = 's3a://hive/case_status_history/',
    format = 'PARQUET'
);

CREATE TABLE hive.landing.judge_court_assignments (
    assignment_id INTEGER,
    judge_id      INTEGER,
    court_id      INTEGER,
    circuit_id    INTEGER,
    assigned_from DATE,
    assigned_to   DATE,
    role          VARCHAR
)
WITH (
    external_location = 's3a://hive/judge_court_assignments/',
    format = 'PARQUET'
);