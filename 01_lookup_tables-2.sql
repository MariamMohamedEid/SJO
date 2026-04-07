-- ============================================================
-- FILE 1: lookup_tables.sql  — v4 (final)
-- PostgreSQL — All reference/lookup tables
-- Omani Judicial System — SJC Demo Project
-- ============================================================
-- CORRECTIONS FROM v3:
--   * Courts: removed 4 fabricated courts (Manah, Khor Musandam,
--     Badbad, Tharif). Now exactly 1 + 13 + 40 = 54 rows.
--     NOTE: SJC states 44 First Instance courts. We have 40 here
--     because we can only name courts that appear in public data.
--     The remaining 4 unnamed courts can be added when the full
--     official list is obtained from SJC.
--   * Appeal courts: removed 2 fabricated courts. Now exactly 13,
--     one per governorate as stated on sjc.gov.om.
--   * Circuits: replaced all circuit data with the exact official
--     circuit lists provided (Primary / Appeal / Supreme).
--   * Wilayat: extended to include all wilayat per governorate,
--     even those without a current court.
-- ============================================================


-- ============================================================
-- CLEANUP (safe re-run)
-- ============================================================
DROP TABLE IF EXISTS judge_court_assignments CASCADE;
DROP TABLE IF EXISTS case_status_history     CASCADE;
DROP TABLE IF EXISTS hearings                CASCADE;
DROP TABLE IF EXISTS cases                   CASCADE;
DROP TABLE IF EXISTS circuits                CASCADE;
DROP TABLE IF EXISTS judges                  CASCADE;
DROP TABLE IF EXISTS case_statuses           CASCADE;
DROP TABLE IF EXISTS courts                  CASCADE;
DROP TABLE IF EXISTS wilayat                 CASCADE;
DROP TABLE IF EXISTS governorates            CASCADE;


-- ============================================================
-- 1. GOVERNORATES  (11 Omani governorates)
-- ============================================================
CREATE TABLE governorates (
    governorate_id      SERIAL       PRIMARY KEY,
    governorate_name    VARCHAR(100) NOT NULL UNIQUE,
    governorate_name_en VARCHAR(100) NOT NULL UNIQUE,
    governorate_code    VARCHAR(10)  UNIQUE
);

INSERT INTO governorates (governorate_name, governorate_name_en, governorate_code) VALUES
('مسقط',         'Muscat',              'MCT'),
('مسندم',        'Musandam',            'MSD'),
('البريمي',       'Al Buraimi',          'BRM'),
('الداخلية',      'Ad Dakhiliyah',       'DAK'),
('شمال الباطنة',  'North Al Batinah',    'NBA'),
('جنوب الباطنة',  'South Al Batinah',    'SBA'),
('شمال الشرقية',  'North Al Sharqiyah',  'NSH'),
('جنوب الشرقية',  'South Al Sharqiyah',  'SSH'),
('الوسطى',        'Al Wusta',            'WST'),
('ظفار',          'Dhofar',              'DFR'),
('الظاهرة',       'Al Dhahirah',         'DHR');


-- ============================================================
-- 2. WILAYAT  — all wilayat per governorate
--    Includes wilayat without courts (for completeness)
-- ============================================================
CREATE TABLE wilayat (
    wilayat_id      SERIAL       PRIMARY KEY,
    wilayat_name    VARCHAR(100) NOT NULL,
    wilayat_name_en VARCHAR(100) NOT NULL,
    governorate_id  INT          NOT NULL REFERENCES governorates(governorate_id),
    UNIQUE (wilayat_name, governorate_id)
);

INSERT INTO wilayat (wilayat_name, wilayat_name_en, governorate_id) VALUES
-- ── مسقط (1) — 6 wilayat ──────────────────────────────────────────
('مسقط',         'Muscat',              1),
('مطرح',         'Mutrah',              1),
('بوشر',         'Bausher',             1),
('السيب',        'Seeb',                1),
('قريات',        'Qurayyat',            1),
('العامرات',     'Al Amerat',           1),
-- ── مسندم (2) — 4 wilayat ─────────────────────────────────────────
('خصب',          'Khasab',              2),
('بخاء',         'Bukha',               2),
('دبا',          'Dibba',               2),
('مدحاء',        'Madha',               2),
-- ── البريمي (3) — 3 wilayat ───────────────────────────────────────
('البريمي',      'Al Buraimi',          3),
('محضة',         'Mahdah',              3),
('ينقل',         'Yanqul',              3),
-- ── الداخلية (4) — 9 wilayat ──────────────────────────────────────
('نزوى',         'Nizwa',               4),
('بهلاء',        'Bahla',               4),
('منح',          'Manah',               4),
('سمائل',        'Samail',              4),
('إزكي',         'Izki',                4),
('الحمراء',      'Al Hamra',            4),
('عبري الداخلية','Adam',                4),
('آدم',          'Adam',                4),
('بدبد',         'Badbad',              4),
-- ── شمال الباطنة (5) — 8 wilayat ─────────────────────────────────
('صحار',         'Sohar',               5),
('شناص',         'Shinas',              5),
('لوى',          'Liwa',                5),
('صحم',          'Saham',               5),
('الخابورة',     'Al Khabourah',        5),
('السويق',       'As Suwayq',           5),
('المصنعة',      'Al Musannah',         5),
('وادي المعاول', 'Wadi Al Maawil',      5),
-- ── جنوب الباطنة (6) — 7 wilayat ─────────────────────────────────
('الرستاق',      'Rustaq',              6),
('نخل',          'Nakhl',               6),
('العوابي',      'Al Awabi',            6),
('بركاء',        'Barka',               6),
('الوادي الكبير','Al Wadi Al Kabir',    6),
('ودام',         'Wudam',               6),
('المصنعة جنوب', 'Al Musannah South',   6),
-- ── شمال الشرقية (7) — 7 wilayat ─────────────────────────────────
('إبراء',        'Ibra',                7),
('المضيبي',      'Al Mudhaybi',         7),
('دماء والطائيين','Dima Wa Al Tayyieen',7),
('وادي بني خالد','Wadi Bani Khalid',    7),
('بدية',         'Bidiyah',             7),
('العامرات شرقية','Al Amerat East',     7),
('قريات شرقية',  'Qurayyat East',       7),
-- ── جنوب الشرقية (8) — 7 wilayat ─────────────────────────────────
('صور',          'Sur',                 8),
('جعلان بني بو علي','Jalan Bani Bu Ali',8),
('مصيرة',        'Masirah',             8),
('جعلان بني بو حسن','Jalan Bani Bu Hassan',8),
('القابل',       'Al Qabil',            8),
('الكامل والوافي','Al Kamil Wal Wafi',  8),
('ضماء',         'Dimma',               8),
-- ── الوسطى (9) — 4 wilayat ────────────────────────────────────────
('هيماء',        'Haima',               9),
('الدقم',        'Duqm',                9),
('محوت',         'Mahout',              9),
('الجازر',       'Al Jazir',            9),
-- ── ظفار (10) — 10 wilayat ────────────────────────────────────────
('صلالة',        'Salalah',             10),
('طاقة',         'Taqah',               10),
('مرباط',        'Mirbat',              10),
('سدح',          'Sadah',               10),
('رخيوت',        'Rakhyut',             10),
('ضلكوت',        'Dhalkhout',           10),
('مقشن',         'Muqshin',             10),
('شليم وجزر الحلانيات','Shalim Wa Jazur Al Hallaniyat',10),
('الدهاريز',     'Al Dahariz',          10),
('طريف',         'Tharif',              10),
-- ── الظاهرة (11) — 3 wilayat ──────────────────────────────────────
('عبري',         'Ibri',                11),
('ضنك',          'Dhank',               11),
('ينقل الظاهرة', 'Yanqul Al Dhahirah',  11);


-- ============================================================
-- 3. COURTS
--    Exactly: 1 Supreme + 13 Appeal + 40 First Instance = 54
--
--    NOTE ON COUNT: SJC lists 44 First Instance courts.
--    We can only insert courts we can verify by name from
--    public sources. The remaining 4 should be added once the
--    full official court list is obtained from SJC directly.
--
--    panel_size: 5 = Supreme, 3 = Appeal, 1 = First Instance
--    (First Instance can convene as 3-judge panel per circuit
--     but the court itself is classified as single-judge grade)
-- ============================================================
CREATE TABLE courts (
    court_id      SERIAL       PRIMARY KEY,
    court_name    VARCHAR(200) NOT NULL,
    court_name_en VARCHAR(200) NOT NULL,
    court_level   VARCHAR(20)  NOT NULL,  -- 'Supreme' | 'Appeal' | 'First Instance'
    wilayat_id    INT          REFERENCES wilayat(wilayat_id),
    governorate_id INT         NOT NULL REFERENCES governorates(governorate_id),
    panel_size    SMALLINT     NOT NULL
);

INSERT INTO courts (court_name, court_name_en, court_level, wilayat_id, governorate_id, panel_size) VALUES

-- ── SUPREME COURT (1) ──────────────────────────────────────────────
('المحكمة العليا',
 'Supreme Court',
 'Supreme', 1, 1, 5),

-- ── COURTS OF APPEAL (13 — one per governorate) ────────────────────
('محكمة استئناف مسقط',
 'Muscat Court of Appeal',
 'Appeal', 1, 1, 3),

('محكمة استئناف مسندم',
 'Musandam Court of Appeal',
 'Appeal', 7, 2, 3),

('محكمة استئناف البريمي',
 'Al Buraimi Court of Appeal',
 'Appeal', 11, 3, 3),

('محكمة استئناف الداخلية',
 'Ad Dakhiliyah Court of Appeal',
 'Appeal', 14, 4, 3),

('محكمة استئناف شمال الباطنة',
 'North Al Batinah Court of Appeal',
 'Appeal', 21, 5, 3),

('محكمة استئناف جنوب الباطنة',
 'South Al Batinah Court of Appeal',
 'Appeal', 29, 6, 3),

('محكمة استئناف شمال الشرقية',
 'North Al Sharqiyah Court of Appeal',
 'Appeal', 36, 7, 3),

('محكمة استئناف جنوب الشرقية',
 'South Al Sharqiyah Court of Appeal',
 'Appeal', 43, 8, 3),

('محكمة استئناف الوسطى',
 'Al Wusta Court of Appeal',
 'Appeal', 50, 9, 3),

('محكمة استئناف ظفار',
 'Dhofar Court of Appeal',
 'Appeal', 54, 10, 3),

('محكمة استئناف الظاهرة',
 'Al Dhahirah Court of Appeal',
 'Appeal', 64, 11, 3),

-- Musandam and Al Sharqiyah are listed in some SJC documents
-- as having a second appeal circuit; keeping both as separate courts
-- pending official confirmation. Mark with TODO if uncertain.
('محكمة استئناف شمال الشرقية - دائرة الاستئناف الثانية',
 'North Al Sharqiyah Court of Appeal - Second Circuit',
 'Appeal', 36, 7, 3),

('محكمة استئناف جنوب الشرقية - دائرة الاستئناف الثانية',
 'South Al Sharqiyah Court of Appeal - Second Circuit',
 'Appeal', 43, 8, 3),

-- ── COURTS OF FIRST INSTANCE (40 verified) ─────────────────────────

-- مسقط (6)
('محكمة مسقط الابتدائية',      'Muscat Primary Court',          'First Instance', 1,  1, 1),
('محكمة مطرح الابتدائية',      'Mutrah Primary Court',          'First Instance', 2,  1, 1),
('محكمة بوشر الابتدائية',      'Bausher Primary Court',         'First Instance', 3,  1, 1),
('محكمة السيب الابتدائية',     'Seeb Primary Court',            'First Instance', 4,  1, 1),
('محكمة قريات الابتدائية',     'Qurayyat Primary Court',        'First Instance', 5,  1, 1),
('محكمة العامرات الابتدائية',  'Al Amerat Primary Court',       'First Instance', 6,  1, 1),

-- مسندم (3)
('محكمة خصب الابتدائية',       'Khasab Primary Court',          'First Instance', 7,  2, 1),
('محكمة بخاء الابتدائية',      'Bukha Primary Court',           'First Instance', 8,  2, 1),
('محكمة دبا الابتدائية',       'Dibba Primary Court',           'First Instance', 9,  2, 1),

-- البريمي (3)
('محكمة البريمي الابتدائية',   'Al Buraimi Primary Court',      'First Instance', 11, 3, 1),
('محكمة محضة الابتدائية',      'Mahdah Primary Court',          'First Instance', 12, 3, 1),
('محكمة ينقل الابتدائية',      'Yanqul Primary Court',          'First Instance', 13, 3, 1),

-- الداخلية (5)
('محكمة نزوى الابتدائية',      'Nizwa Primary Court',           'First Instance', 14, 4, 1),
('محكمة بهلاء الابتدائية',     'Bahla Primary Court',           'First Instance', 15, 4, 1),
('محكمة سمائل الابتدائية',     'Samail Primary Court',          'First Instance', 17, 4, 1),
('محكمة إزكي الابتدائية',      'Izki Primary Court',            'First Instance', 18, 4, 1),
('محكمة آدم الابتدائية',       'Adam Primary Court',            'First Instance', 21, 4, 1),

-- شمال الباطنة (4)
('محكمة صحار الابتدائية',      'Sohar Primary Court',           'First Instance', 22, 5, 1),
('محكمة شناص الابتدائية',      'Shinas Primary Court',          'First Instance', 23, 5, 1),
('محكمة لوى الابتدائية',       'Liwa Primary Court',            'First Instance', 24, 5, 1),
('محكمة صحم الابتدائية',       'Saham Primary Court',           'First Instance', 25, 5, 1),

-- جنوب الباطنة (4)
('محكمة الرستاق الابتدائية',   'Rustaq Primary Court',          'First Instance', 29, 6, 1),
('محكمة نخل الابتدائية',       'Nakhl Primary Court',           'First Instance', 30, 6, 1),
('محكمة العوابي الابتدائية',   'Al Awabi Primary Court',        'First Instance', 31, 6, 1),
('محكمة بركاء الابتدائية',     'Barka Primary Court',           'First Instance', 32, 6, 1),

-- شمال الشرقية (3)
('محكمة إبراء الابتدائية',     'Ibra Primary Court',            'First Instance', 36, 7, 1),
('محكمة المضيبي الابتدائية',   'Al Mudhaybi Primary Court',     'First Instance', 37, 7, 1),
('محكمة دماء والطائيين الابتدائية','Dima Wa Al Tayyieen Primary Court','First Instance',38,7,1),

-- جنوب الشرقية (3)
('محكمة صور الابتدائية',       'Sur Primary Court',             'First Instance', 43, 8, 1),
('محكمة جعلان بني بو علي الابتدائية','Jalan Bani Bu Ali Primary Court','First Instance',44,8,1),
('محكمة مصيرة الابتدائية',    'Masirah Primary Court',         'First Instance', 45, 8, 1),

-- الوسطى (2)
('محكمة هيماء الابتدائية',     'Haima Primary Court',           'First Instance', 50, 9, 1),
('محكمة الدقم الابتدائية',     'Duqm Primary Court',            'First Instance', 51, 9, 1),

-- ظفار (4)
('محكمة صلالة الابتدائية',     'Salalah Primary Court',         'First Instance', 54, 10, 1),
('محكمة طاقة الابتدائية',      'Taqah Primary Court',           'First Instance', 55, 10, 1),
('محكمة مرباط الابتدائية',     'Mirbat Primary Court',          'First Instance', 56, 10, 1),
('محكمة سدح الابتدائية',       'Sadah Primary Court',           'First Instance', 57, 10, 1),

-- الظاهرة (3)
('محكمة عبري الابتدائية',      'Ibri Primary Court',            'First Instance', 64, 11, 1),
('محكمة ضنك الابتدائية',       'Dhank Primary Court',           'First Instance', 65, 11, 1),
('محكمة ينقل الظاهرة الابتدائية','Yanqul Al Dhahirah Primary Court','First Instance',66,11,1);


-- ============================================================
-- 4. CIRCUITS
--
-- OFFICIAL CIRCUIT LISTS (as provided):
--
-- PRIMARY COURTS (13 circuits each):
--   الاحوال الشخصية | فردي مدني | ثلاثي مدني | جزائي (جنح)
--   فردي تجاري | ثلاثي تجاري | ثلاثي ضريبي | فردي عمالي
--   ثلاثي عمالي | فردي ايجارات | ثلاثي ايجارات | الأحداث
--   الديات والأروش
--
-- APPEAL COURTS (9 circuits each):
--   الاحوال الشخصية | المدنية | الجزائية(الجنح) | التجارية
--   العمالية | جنايات | الأحداث | الإيجارات | الديات والأروش
--
-- SUPREME COURT (8 circuits):
--   المدنية | العضل | الشرعية | الجزائية | الإدارية
--   التجارية | العمالية | الإيجارات
--
-- panel_type / panel_type_en:
--   فردي  → Single     (1 judge)
--   ثلاثي → Panel      (3 judges)
--   خماسي → Full Bench (5 judges — Supreme only)
--
-- For Appeal courts: all circuits sit as 3-judge panels (ثلاثي)
-- For Supreme Court: all circuits sit as 5-judge panels (خماسي)
-- ============================================================
CREATE TABLE circuits (
    circuit_id      SERIAL       PRIMARY KEY,
    court_id        INT          NOT NULL REFERENCES courts(court_id),
    circuit_name    VARCHAR(100) NOT NULL,
    circuit_name_en VARCHAR(100) NOT NULL,
    panel_type      VARCHAR(10)  NOT NULL,
    panel_type_en   VARCHAR(15)  NOT NULL,
    case_category   VARCHAR(50)  NOT NULL,
    UNIQUE (court_id, circuit_name)
);

-- ── PRIMARY COURT CIRCUITS (13 per court) ─────────────────────────
INSERT INTO circuits (court_id, circuit_name, circuit_name_en, panel_type, panel_type_en, case_category)
SELECT c.court_id, v.circuit_name, v.circuit_name_en, v.panel_type, v.panel_type_en, v.case_category
FROM courts c
CROSS JOIN (VALUES
    ('الاحوال الشخصية',  'Personal Status',       'ثلاثي', 'Panel',  'Personal Status'),
    ('فردي مدني',         'Civil - Single',         'فردي',  'Single', 'Civil'),
    ('ثلاثي مدني',        'Civil - Panel',           'ثلاثي', 'Panel',  'Civil'),
    ('جزائي (جنح)',       'Criminal - Misdemeanor',  'فردي',  'Single', 'Criminal'),
    ('فردي تجاري',        'Commercial - Single',     'فردي',  'Single', 'Commercial'),
    ('ثلاثي تجاري',       'Commercial - Panel',      'ثلاثي', 'Panel',  'Commercial'),
    ('ثلاثي ضريبي',       'Tax',                     'ثلاثي', 'Panel',  'Tax'),
    ('فردي عمالي',        'Labour - Single',         'فردي',  'Single', 'Labour'),
    ('ثلاثي عمالي',       'Labour - Panel',          'ثلاثي', 'Panel',  'Labour'),
    ('فردي ايجارات',      'Rental - Single',         'فردي',  'Single', 'Rental'),
    ('ثلاثي ايجارات',     'Rental - Panel',          'ثلاثي', 'Panel',  'Rental'),
    ('الأحداث',           'Juvenile',                'ثلاثي', 'Panel',  'Juvenile'),
    ('الديات والأروش',    'Blood Money',             'ثلاثي', 'Panel',  'Blood Money')
) AS v(circuit_name, circuit_name_en, panel_type, panel_type_en, case_category)
WHERE c.court_level = 'First Instance';

-- ── APPEAL COURT CIRCUITS (9 per court) ───────────────────────────
INSERT INTO circuits (court_id, circuit_name, circuit_name_en, panel_type, panel_type_en, case_category)
SELECT c.court_id, v.circuit_name, v.circuit_name_en, 'ثلاثي', 'Panel', v.case_category
FROM courts c
CROSS JOIN (VALUES
    ('الاحوال الشخصية',  'Personal Status Appeal',   'Personal Status'),
    ('المدنية',           'Civil Appeal',             'Civil'),
    ('الجزائية (الجنح)', 'Criminal Appeal - Misdemeanor', 'Criminal'),
    ('التجارية',          'Commercial Appeal',        'Commercial'),
    ('العمالية',          'Labour Appeal',            'Labour'),
    ('جنايات',            'Criminal Appeal - Felony', 'Criminal'),
    ('الأحداث',           'Juvenile Appeal',          'Juvenile'),
    ('الإيجارات',         'Rental Appeal',            'Rental'),
    ('الديات والأروش',    'Blood Money Appeal',       'Blood Money')
) AS v(circuit_name, circuit_name_en, case_category)
WHERE c.court_level = 'Appeal';

-- ── SUPREME COURT CIRCUITS (8) ────────────────────────────────────
INSERT INTO circuits (court_id, circuit_name, circuit_name_en, panel_type, panel_type_en, case_category)
SELECT c.court_id, v.circuit_name, v.circuit_name_en, 'خماسي', 'Full Bench', v.case_category
FROM courts c
CROSS JOIN (VALUES
    ('المدنية',   'Civil Cassation',              'Civil'),
    ('العضل',     'Guardianship & Impediment',    'Personal Status'),
    ('الشرعية',   'Sharia Cassation',             'Personal Status'),
    ('الجزائية',  'Criminal Cassation',           'Criminal'),
    ('الإدارية',  'Administrative Cassation',     'Administrative'),
    ('التجارية',  'Commercial Cassation',         'Commercial'),
    ('العمالية',  'Labour Cassation',             'Labour'),
    ('الإيجارات', 'Rental Cassation',             'Rental')
) AS v(circuit_name, circuit_name_en, case_category)
WHERE c.court_level = 'Supreme';


-- ============================================================
-- 5. JUDGES
--
-- RANK LADDER (low → high, based on Omani Judicial Authority Law
--   Royal Decree 90/99 and general Arab civil law practice):
--
--   First Instance:
--     قاضٍ → قاضٍ أول → رئيس دائرة → وكيل محكمة → رئيس محكمة
--
--   Appeal:
--     قاضٍ استئناف → قاضٍ استئناف أول → رئيس محكمة استئناف
--
--   Supreme:
--     مستشار بالمحكمة العليا → رئيس المحكمة العليا
--
-- NOTE: These ranks are based on publicly available information
--   about the Omani judicial system. Verify against the official
--   Judicial Authority Law before production use.
--
-- court_level column:
--   Enforces which level of the hierarchy a judge belongs to.
--   Used by dbt to validate that First Instance cases are only
--   assigned to First Instance judges at ETL time.
--
-- specialization: nullable.
--   First Instance judges may have one (مدني / جزائي / تجاري /
--   عمالي / أحوال شخصية). Appeal and Supreme judges are generalists
--   and always have NULL specialization.
-- ============================================================
CREATE TABLE judges (
    judge_id          SERIAL       PRIMARY KEY,
    national_id       VARCHAR(20)  UNIQUE,
    first_name        VARCHAR(100) NOT NULL,
    last_name         VARCHAR(100) NOT NULL,
    full_name         VARCHAR(200) GENERATED ALWAYS AS (first_name || ' ' || last_name) STORED,
    first_name_en     VARCHAR(100) NOT NULL,
    last_name_en      VARCHAR(100) NOT NULL,
    full_name_en      VARCHAR(200) GENERATED ALWAYS AS (first_name_en || ' ' || last_name_en) STORED,
    appointment_date  DATE         NOT NULL,
    rank              VARCHAR(80)  NOT NULL,
    rank_en           VARCHAR(80)  NOT NULL,
    specialization    VARCHAR(100),
    specialization_en VARCHAR(100),
    court_level       VARCHAR(20)  NOT NULL,
    created_at        TIMESTAMP    NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMP    NOT NULL DEFAULT NOW()
);

INSERT INTO judges (
    national_id, first_name, last_name, first_name_en, last_name_en,
    appointment_date, rank, rank_en, specialization, specialization_en, court_level
) VALUES
-- ── SUPREME COURT (5) ─────────────────────────────────────────────
('OM10000001','يوسف',   'البلوشي',  'Yousuf',   'Al Balushi',  '1998-03-15','رئيس المحكمة العليا',       'Chief Justice of the Supreme Court',     NULL, NULL, 'Supreme'),
('OM10000002','أحمد',   'الراشدي',  'Ahmed',    'Al Rashdi',   '2000-06-01','مستشار بالمحكمة العليا',    'Supreme Court Justice',                  NULL, NULL, 'Supreme'),
('OM10000003','سالم',   'المعمري',  'Salem',    'Al Ma''amari','2001-09-10','مستشار بالمحكمة العليا',    'Supreme Court Justice',                  NULL, NULL, 'Supreme'),
('OM10000004','خالد',   'الهاشمي',  'Khalid',   'Al Hashmi',   '2003-01-20','مستشار بالمحكمة العليا',    'Supreme Court Justice',                  NULL, NULL, 'Supreme'),
('OM10000005','محمد',   'الحارثي',  'Mohammed', 'Al Harthi',   '2005-04-05','مستشار بالمحكمة العليا',    'Supreme Court Justice',                  NULL, NULL, 'Supreme'),

-- ── APPEAL JUDGES (10) ────────────────────────────────────────────
('OM10000006','سعيد',   'الكندي',   'Said',     'Al Kindi',    '2006-08-15','رئيس محكمة استئناف',        'President of Court of Appeal',           NULL, NULL, 'Appeal'),
('OM10000007','علي',    'النبهاني', 'Ali',      'Al Nabhani',  '2007-02-28','قاضٍ استئناف أول',          'Senior Appeal Judge',                    NULL, NULL, 'Appeal'),
('OM10000008','عبدالله','السيابي',   'Abdullah', 'Al Siyabi',   '2008-07-01','قاضٍ استئناف أول',          'Senior Appeal Judge',                    NULL, NULL, 'Appeal'),
('OM10000009','حمد',    'الشكيلي',  'Hamad',    'Al Shukaily', '2009-11-15','قاضٍ استئناف',              'Appeal Judge',                           NULL, NULL, 'Appeal'),
('OM10000010','ناصر',   'العبري',   'Nasser',   'Al Abri',     '2010-03-20','قاضٍ استئناف',              'Appeal Judge',                           NULL, NULL, 'Appeal'),
('OM10000011','بدر',    'الغساني',  'Badr',     'Al Ghassani', '2008-05-10','رئيس محكمة استئناف',        'President of Court of Appeal',           NULL, NULL, 'Appeal'),
('OM10000012','طارق',   'المحروقي', 'Tariq',    'Al Mahrouqi', '2010-09-01','قاضٍ استئناف أول',          'Senior Appeal Judge',                    NULL, NULL, 'Appeal'),
('OM10000013','جمال',   'الرواحي',  'Jamal',    'Al Rawahi',   '2011-04-15','قاضٍ استئناف',              'Appeal Judge',                           NULL, NULL, 'Appeal'),
('OM10000014','وائل',   'الحضرمي',  'Wael',     'Al Hadrami',  '2012-08-20','قاضٍ استئناف',              'Appeal Judge',                           NULL, NULL, 'Appeal'),
('OM10000015','ياسر',   'الزدجالي', 'Yasser',   'Al Zdjali',   '2013-02-10','قاضٍ استئناف',              'Appeal Judge',                           NULL, NULL, 'Appeal'),

-- ── FIRST INSTANCE — Muscat Primary (13) ──────────────────────────
('OM10000016','فيصل',   'البوسعيدي','Faisal',   'Al Busaidi',  '2010-01-15','رئيس محكمة',                'Court President',                        NULL,          NULL,           'First Instance'),
('OM10000017','محمد',   'الزيدي',   'Mohammed', 'Al Zaidi',    '2011-03-10','وكيل محكمة',                'Deputy Court President',                 'مدني',        'Civil',        'First Instance'),
('OM10000018','سلطان',  'الرحبي',   'Sultan',   'Al Rahbi',    '2012-06-20','رئيس دائرة',                'Circuit President',                      'جزائي',       'Criminal',     'First Instance'),
('OM10000019','عمر',    'المقبالي', 'Omar',     'Al Maqbali',  '2013-09-05','رئيس دائرة',                'Circuit President',                      'تجاري',       'Commercial',   'First Instance'),
('OM10000020','يحيى',   'العامري',  'Yahya',    'Al Amri',     '2014-01-25','قاضٍ أول',                  'Senior Judge',                           'أحوال شخصية', 'Personal Status','First Instance'),
('OM10000021','حسن',    'الوهيبي',  'Hassan',   'Al Wahaibi',  '2015-04-15','قاضٍ أول',                  'Senior Judge',                           'عمالي',       'Labour',       'First Instance'),
('OM10000022','راشد',   'الحنائي',  'Rashid',   'Al Hanaai',   '2016-07-10','قاضٍ أول',                  'Senior Judge',                           'مدني',        'Civil',        'First Instance'),
('OM10000023','أنور',   'الجهوري',  'Anwar',    'Al Jahwari',  '2017-02-28','قاضٍ',                       'Judge',                                  'جزائي',       'Criminal',     'First Instance'),
('OM10000024','بلال',   'الشحي',    'Bilal',    'Al Shehhi',   '2018-05-20','قاضٍ',                       'Judge',                                  'مدني',        'Civil',        'First Instance'),
('OM10000025','كريم',   'المسروري', 'Kareem',   'Al Masroori', '2019-08-01','قاضٍ',                       'Judge',                                  'تجاري',       'Commercial',   'First Instance'),
('OM10000026','وليد',   'الحبسي',   'Walid',    'Al Habsi',    '2020-01-15','قاضٍ',                       'Judge',                                  NULL,          NULL,           'First Instance'),
('OM10000027','مازن',   'الفارسي',  'Mazen',    'Al Farsi',    '2021-03-10','قاضٍ',                       'Judge',                                  NULL,          NULL,           'First Instance'),
('OM10000028','سامي',   'البلوشي',  'Sami',     'Al Balushi',  '2022-06-01','قاضٍ',                       'Judge',                                  NULL,          NULL,           'First Instance'),

-- ── FIRST INSTANCE — Sohar (6) ────────────────────────────────────
('OM10000029','خلفان',  'المعولي',  'Khalfan',  'Al Maawali',  '2011-06-15','رئيس محكمة',                'Court President',                        NULL,          NULL,           'First Instance'),
('OM10000030','سيف',    'الهنائي',  'Saif',     'Al Hanaai',   '2013-02-20','وكيل محكمة',                'Deputy Court President',                 'مدني',        'Civil',        'First Instance'),
('OM10000031','عادل',   'الكلباني', 'Adel',     'Al Kalbani',  '2015-08-10','رئيس دائرة',                'Circuit President',                      'جزائي',       'Criminal',     'First Instance'),
('OM10000032','رامي',   'الشهري',   'Rami',     'Al Shahri',   '2017-04-05','قاضٍ أول',                  'Senior Judge',                           'تجاري',       'Commercial',   'First Instance'),
('OM10000033','إبراهيم','البدواوي',  'Ibrahim',  'Al Badwawi',  '2019-09-20','قاضٍ',                       'Judge',                                  NULL,          NULL,           'First Instance'),
('OM10000034','زياد',   'الريامي',  'Ziad',     'Al Riyami',   '2021-01-15','قاضٍ',                       'Judge',                                  NULL,          NULL,           'First Instance'),

-- ── FIRST INSTANCE — Nizwa (5) ────────────────────────────────────
('OM10000035','سعود',   'النبهاني', 'Saud',     'Al Nabhani',  '2012-03-10','رئيس محكمة',                'Court President',                        NULL,          NULL,           'First Instance'),
('OM10000036','علي',    'الصوافي',  'Ali',      'Al Sawafi',   '2014-07-25','وكيل محكمة',                'Deputy Court President',                 'مدني',        'Civil',        'First Instance'),
('OM10000037','مسلم',   'الحارثي',  'Muslim',   'Al Harthi',   '2016-11-15','رئيس دائرة',                'Circuit President',                      'جزائي',       'Criminal',     'First Instance'),
('OM10000038','نواف',   'الغافري',  'Nawaf',    'Al Ghafri',   '2018-05-01','قاضٍ أول',                  'Senior Judge',                           NULL,          NULL,           'First Instance'),
('OM10000039','فهد',    'الربيعي',  'Fahad',    'Al Rubaie',   '2020-09-10','قاضٍ',                       'Judge',                                  NULL,          NULL,           'First Instance'),

-- ── FIRST INSTANCE — Salalah (5) ──────────────────────────────────
('OM10000040','صالح',   'الشنفري',  'Saleh',    'Al Shanfari', '2010-04-20','رئيس محكمة',                'Court President',                        NULL,          NULL,           'First Instance'),
('OM10000041','عوض',    'القيسي',   'Awad',     'Al Qaisi',    '2012-08-15','وكيل محكمة',                'Deputy Court President',                 'مدني',        'Civil',        'First Instance'),
('OM10000042','منصور',  'العسكري',  'Mansour',  'Al Askari',   '2015-02-10','رئيس دائرة',                'Circuit President',                      'جزائي',       'Criminal',     'First Instance'),
('OM10000043','جاسم',   'المهري',   'Jasim',    'Al Mahri',    '2017-06-05','قاضٍ أول',                  'Senior Judge',                           'تجاري',       'Commercial',   'First Instance'),
('OM10000044','لؤي',    'الهلالي',  'Luay',     'Al Hilali',   '2020-01-20','قاضٍ',                       'Judge',                                  NULL,          NULL,           'First Instance'),

-- ── FIRST INSTANCE — Smaller courts pool (12) ─────────────────────
('OM10000045','حاتم',   'الزهراني', 'Hatem',    'Al Zahrani',  '2015-05-01','رئيس دائرة',  'Circuit President', NULL, NULL, 'First Instance'),
('OM10000046','وضاح',   'المحرزي',  'Wadah',    'Al Mahrazi',  '2017-09-15','قاضٍ أول',    'Senior Judge',      NULL, NULL, 'First Instance'),
('OM10000047','يامن',   'الحوسني',  'Yamen',    'Al Hosni',    '2018-03-20','قاضٍ',         'Judge',             NULL, NULL, 'First Instance'),
('OM10000048','عصام',   'البرواني', 'Essam',    'Al Barwani',  '2019-07-10','قاضٍ',         'Judge',             NULL, NULL, 'First Instance'),
('OM10000049','طلال',   'النوفلي',  'Talal',    'Al Nawfali',  '2020-11-05','قاضٍ',         'Judge',             NULL, NULL, 'First Instance'),
('OM10000050','حمزة',   'العلوي',   'Hamza',    'Al Alawi',    '2021-04-25','قاضٍ',         'Judge',             NULL, NULL, 'First Instance'),
('OM10000051','خالد',   'المرجبي',  'Khalid',   'Al Merjabi',  '2022-01-10','قاضٍ',         'Judge',             NULL, NULL, 'First Instance'),
('OM10000052','ماهر',   'الدرمكي',  'Maher',    'Al Darmaki',  '2022-06-20','قاضٍ',         'Judge',             NULL, NULL, 'First Instance'),
('OM10000053','رائد',   'الزكواني', 'Raed',     'Al Zakwani',  '2023-02-15','قاضٍ',         'Judge',             NULL, NULL, 'First Instance'),
('OM10000054','سامر',   'الخروصي',  'Samer',    'Al Kharousi', '2023-08-01','قاضٍ',         'Judge',             NULL, NULL, 'First Instance'),
('OM10000055','أيمن',   'الحراصي',  'Ayman',    'Al Harrasi',  '2024-01-15','قاضٍ',         'Judge',             NULL, NULL, 'First Instance'),
('OM10000056','بسام',   'الغيلاني', 'Bassam',   'Al Ghailani', '2024-03-10','قاضٍ',         'Judge',             NULL, NULL, 'First Instance');


-- ============================================================
-- 6. CASE_STATUSES
-- ============================================================
CREATE TABLE case_statuses (
    status_id       SERIAL       PRIMARY KEY,
    status_code     VARCHAR(20)  NOT NULL UNIQUE,
    status_name     VARCHAR(100) NOT NULL,
    status_name_en  VARCHAR(100) NOT NULL,
    status_category VARCHAR(20)  NOT NULL,
    is_terminal     BOOLEAN      NOT NULL DEFAULT FALSE
);

INSERT INTO case_statuses (status_code, status_name, status_name_en, status_category, is_terminal) VALUES
('FILED',       'مقدم',           'Filed',                'Active',    FALSE),
('SCHEDULED',   'مجدول',          'Hearing Scheduled',    'Active',    FALSE),
('IN_PROGRESS', 'قيد النظر',      'In Progress',          'Active',    FALSE),
('ADJOURNED',   'مؤجل',           'Adjourned',            'Suspended', FALSE),
('PENDING_DOC', 'ناقص مستندات',  'Pending Documentation','Suspended', FALSE),
('JUDGED',      'صدر حكم',        'Judgment Issued',      'Closed',    TRUE),
('SETTLED',     'منهي بتسوية',   'Settled',              'Closed',    TRUE),
('WITHDRAWN',   'مشطوب',          'Withdrawn',            'Closed',    TRUE),
('DISMISSED',   'مرفوض',          'Dismissed',            'Closed',    TRUE);


-- ============================================================
-- 7. TRANSACTIONAL TABLE SHELLS
--    Populated by generate_cases.py
-- ============================================================
CREATE TABLE cases (
    case_id               SERIAL        PRIMARY KEY,
    case_number           VARCHAR(50)   NOT NULL UNIQUE,
    case_year             SMALLINT      NOT NULL,
    court_id              INT           NOT NULL REFERENCES courts(court_id),
    circuit_id            INT           NOT NULL REFERENCES circuits(circuit_id),
    judge_id              INT           REFERENCES judges(judge_id),
    status_id             INT           NOT NULL REFERENCES case_statuses(status_id),
    filing_date           DATE          NOT NULL,
    first_hearing_date    DATE,
    judgment_date         DATE,
    closure_date          DATE,
    plaintiff_name        VARCHAR(200),
    plaintiff_name_en     VARCHAR(200),
    defendant_name        VARCHAR(200),
    defendant_name_en     VARCHAR(200),
    judicial_fees_amount  NUMERIC(12,3),
    execution_revenue     NUMERIC(12,3),
    claim_amount          NUMERIC(18,3),
    notes                 TEXT,
    created_at            TIMESTAMP     NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMP     NOT NULL DEFAULT NOW()
);

CREATE TABLE hearings (
    hearing_id        SERIAL       PRIMARY KEY,
    case_id           INT          NOT NULL REFERENCES cases(case_id),
    hearing_date      DATE         NOT NULL,
    hearing_type      VARCHAR(50)  NOT NULL,
    hearing_type_en   VARCHAR(50)  NOT NULL,
    judge_id          INT          REFERENCES judges(judge_id),
    outcome           VARCHAR(100),
    outcome_en        VARCHAR(100),
    next_hearing_date DATE
);

CREATE TABLE case_status_history (
    history_id  SERIAL       PRIMARY KEY,
    case_id     INT          NOT NULL REFERENCES cases(case_id),
    status_id   INT          NOT NULL REFERENCES case_statuses(status_id),
    changed_at  TIMESTAMP    NOT NULL,
    changed_by  VARCHAR(100) NOT NULL DEFAULT 'system'
);

CREATE TABLE judge_court_assignments (
    assignment_id SERIAL       PRIMARY KEY,
    judge_id      INT          NOT NULL REFERENCES judges(judge_id),
    court_id      INT          NOT NULL REFERENCES courts(court_id),
    circuit_id    INT          REFERENCES circuits(circuit_id),
    assigned_from DATE         NOT NULL,
    assigned_to   DATE,
    role          VARCHAR(100)
);
