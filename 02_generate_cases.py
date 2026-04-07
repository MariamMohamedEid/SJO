"""
generate_cases.py  — v3
========================
Changes from v2:
  * SPEC_TO_CATEGORY updated: 'ايجارات' added to match the new
    official circuit name 'فردي ايجارات' / 'ثلاثي ايجارات'
    (was 'إيجارات' with hamza, now without — match exactly what
    is stored in the circuits table).
  * case_category values aligned with the official circuit list:
    'Tax', 'Blood Money', 'Juvenile' remain as-is.
    'Rental' maps to both فردي ايجارات and ثلاثي ايجارات.
  * FEES_BY_CATEGORY and CLAIM_BY_CATEGORY unchanged — still
    keyed on English case_category names returned by the DB.
  * No structural changes — only the mapping dictionaries updated.
"""

import psycopg2
import random
from datetime import date, timedelta, datetime

# ── CONFIG ────────────────────────────────────────────────────────────────────
DB_CONFIG = {
    "host":     "localhost",
    "port":     5432,
    "dbname":   "judicial_db",
    "user":     "admin",
    "password": "admin",
}
NUM_CASES   = 1000
RANDOM_SEED = 42
random.seed(RANDOM_SEED)

# ── STATUS CONFIG ─────────────────────────────────────────────────────────────
STATUS_WEIGHTS = {
    "JUDGED":      45,
    "IN_PROGRESS": 20,
    "ADJOURNED":   12,
    "SCHEDULED":   10,
    "SETTLED":      7,
    "WITHDRAWN":    4,
    "DISMISSED":    2,
}
CLOSED_STATUSES = {"JUDGED", "SETTLED", "WITHDRAWN", "DISMISSED"}

# ── HEARING DEFINITIONS ───────────────────────────────────────────────────────
HEARING_TYPES = [
    ("جلسة أولى",             "Initial Hearing"),
    ("جلسة إثبات",            "Evidence Hearing"),
    ("جلسة مرافعة",           "Pleading Hearing"),
    ("جلسة استماع شهود",      "Witness Hearing"),
    ("جلسة تقرير خبير",       "Expert Report Hearing"),
    ("جلسة مداولة",           "Deliberation Session"),
    ("جلسة النطق بالحكم",     "Judgment Pronouncement"),
]
OPEN_OUTCOMES = [
    ("تأجيل لحضور المدعى عليه", "Adjourned - defendant absent"),
    ("تأجيل لتقديم مستندات",   "Adjourned - pending documents"),
    ("تحديد جلسة ثانية",       "Second hearing scheduled"),
    ("قبول المرافعات",          "Pleadings accepted"),
    ("إحالة لخبير",             "Referred to expert"),
]
CLOSED_OUTCOMES = [
    ("قبول المرافعات",  "Pleadings accepted"),
    ("حجز للحكم",       "Reserved for judgment"),
    ("النطق بالحكم",    "Judgment pronounced"),
]

# ── NAME POOLS (index-paired AR <-> EN) ───────────────────────────────────────
PLAINTIFF_AR = [
    "شركة الخليج للتجارة والاستيراد",
    "مؤسسة النور للمقاولات",
    "شركة عُمان للاستثمار والتطوير",
    "شركة الوادي للخدمات اللوجستية",
    "بنك مسقط",
    "شركة الشرق للمقاولات والبناء",
    "مؤسسة البركة التجارية",
    "شركة الخليج العربي للنفط",
    "أحمد بن سالم المعمري",
    "فاطمة بنت علي الحارثية",
    "محمد بن ناصر البلوشي",
    "سلطان بن خلفان الراشدي",
    "خديجة بنت سعيد الكندية",
    "يوسف بن حمد المقبالي",
    "عائشة بنت عمر السيابية",
    "ناصر بن خالد العبري",
    "سعيد بن علي الشكيلي",
    "مريم بنت محمد الغافرية",
    "هيئة المنطقة الاقتصادية بالدقم",
    "شركة تنمية نفط عُمان",
]
PLAINTIFF_EN = [
    "Al Khalij Trading & Import Co.",
    "Al Nour Construction Est.",
    "Oman Investment & Development Co.",
    "Al Wadi Logistics Services Co.",
    "Bank Muscat",
    "Al Sharq Construction & Building Co.",
    "Al Baraka Trading Est.",
    "Arabian Gulf Petroleum Co.",
    "Ahmed bin Salem Al Ma'amari",
    "Fatima bint Ali Al Harthi",
    "Mohammed bin Nasser Al Balushi",
    "Sultan bin Khalfan Al Rashdi",
    "Khadija bint Said Al Kindi",
    "Yousuf bin Hamad Al Maqbali",
    "Aisha bint Omar Al Siyabi",
    "Nasser bin Khalid Al Abri",
    "Said bin Ali Al Shukaily",
    "Mariam bint Mohammed Al Ghafri",
    "Special Economic Zone Authority at Duqm",
    "Petroleum Development Oman (PDO)",
]
DEFENDANT_AR = [
    "شركة مسقط للعقارات والتطوير",
    "وزارة المالية - سلطنة عُمان",
    "شركة صحار للصناعة والتجارة",
    "مؤسسة الشمال للمقاولات",
    "شركة الباطنة للخدمات",
    "ناصر بن حمد الكندي",
    "خالد بن عمر الغافري",
    "علي بن سعيد المقبالي",
    "شركة أوريدو عُمان للاتصالات",
    "مؤسسة الرستاق للتجارة",
    "سلطان بن أحمد البوسعيدي",
    "بنك ظفار",
    "شركة الدقم للتطوير الاقتصادي",
    "هيئة تنظيم الاتصالات",
    "عمر بن راشد الهاشمي",
    "شركة النهضة للمقاولات",
    "حمد بن خالد الشيذاني",
    "وزارة الإسكان والتخطيط العمراني",
    "مؤسسة الخليج للخدمات البترولية",
    "بنك صحار الدولي",
]
DEFENDANT_EN = [
    "Muscat Real Estate & Development Co.",
    "Ministry of Finance - Sultanate of Oman",
    "Sohar Industry & Trade Co.",
    "Al Shamal Construction Est.",
    "Al Batinah Services Co.",
    "Nasser bin Hamad Al Kindi",
    "Khalid bin Omar Al Ghafri",
    "Ali bin Said Al Maqbali",
    "Ooredoo Oman Telecommunications Co.",
    "Rustaq Trading Est.",
    "Sultan bin Ahmed Al Busaidi",
    "Bank Dhofar",
    "Duqm Economic Development Co.",
    "Telecommunications Regulatory Authority",
    "Omar bin Rashid Al Hashmi",
    "Al Nahda Construction Co.",
    "Hamad bin Khalid Al Shaidhani",
    "Ministry of Housing and Urban Planning",
    "Gulf Petroleum Services Est.",
    "Sohar International Bank",
]

# ── FINANCIAL RANGES (OMR) ────────────────────────────────────────────────────
# Keys must match the case_category values stored in the circuits table exactly.
FEES_BY_CATEGORY = {
    "Civil":            (50,   2000),
    "Criminal":         (30,    500),
    "Commercial":       (200,  5000),
    "Labour":           (20,    800),
    "Personal Status":  (30,    300),
    "Rental":           (50,    500),
    "Tax":              (500,  8000),
    "Juvenile":         (10,    100),
    "Blood Money":      (500,  5000),
    "Administrative":   (100,  2000),
}
CLAIM_BY_CATEGORY = {
    "Civil":            (1000,   100000),
    "Criminal":         (0,           0),   # no civil claim in criminal cases
    "Commercial":       (5000,   500000),
    "Labour":           (500,     20000),
    "Personal Status":  (0,           0),
    "Rental":           (500,     30000),
    "Tax":              (10000,  500000),
    "Juvenile":         (0,           0),
    "Blood Money":      (5000,   200000),
    "Administrative":   (1000,    50000),
}

# ── JUDGE SPECIALIZATION → CIRCUIT case_category ──────────────────────────────
# Maps the Arabic specialization stored in judges.specialization
# to the English case_category stored in circuits.case_category.
# These must match what the DB actually contains.
SPEC_TO_CATEGORY = {
    "مدني":          "Civil",
    "جزائي":         "Criminal",
    "تجاري":         "Commercial",
    "عمالي":         "Labour",
    "أحوال شخصية":  "Personal Status",
    "ايجارات":       "Rental",     # without hamza — matches circuit table
}


# ── HELPERS ───────────────────────────────────────────────────────────────────
def random_date(start: date, end: date) -> date:
    return start + timedelta(days=random.randint(0, (end - start).days))


def weighted_choice(weight_dict: dict) -> str:
    keys    = list(weight_dict.keys())
    weights = list(weight_dict.values())
    return random.choices(keys, weights=weights, k=1)[0]


def build_status_history(
    case_id: int,
    status_code: str,
    filing_date: date,
    first_hearing_date: date,
    closure_date,
    status_map: dict,
) -> list:
    """
    Returns [(case_id, status_id, changed_at), ...]
    Trail: FILED -> SCHEDULED -> IN_PROGRESS -> [terminal if closed]
    """
    rows = []
    rows.append((
        case_id,
        status_map["FILED"],
        datetime.combine(filing_date, datetime.min.time()),
    ))
    if first_hearing_date:
        sched = first_hearing_date - timedelta(days=random.randint(3, 10))
        rows.append((
            case_id,
            status_map["SCHEDULED"],
            datetime.combine(sched, datetime.min.time()),
        ))
        rows.append((
            case_id,
            status_map["IN_PROGRESS"],
            datetime.combine(first_hearing_date, datetime.min.time()),
        ))
    if status_code not in ("FILED", "SCHEDULED", "IN_PROGRESS"):
        terminal_date = closure_date or (
            first_hearing_date + timedelta(days=random.randint(10, 30))
            if first_hearing_date
            else filing_date + timedelta(days=30)
        )
        rows.append((
            case_id,
            status_map[status_code],
            datetime.combine(terminal_date, datetime.min.time()),
        ))
    return rows


def build_hearings(
    case_id: int,
    judge_id: int,
    status_code: str,
    first_hearing_date: date,
    judgment_date,
    closure_date,
) -> list:
    """
    Returns list of hearing dicts ready for INSERT.
    Closed cases: 2-5 hearings ending with judgment pronouncement.
    Open cases:   1-3 hearings, last one adjourned.
    """
    if not first_hearing_date:
        return []

    is_closed = status_code in CLOSED_STATUSES
    num       = random.randint(2, 5) if is_closed else random.randint(1, 3)
    end_date  = (judgment_date or closure_date or
                 first_hearing_date + timedelta(days=90))

    span = max((end_date - first_hearing_date).days, num * 21)
    h_dates = sorted([
        first_hearing_date + timedelta(days=int(i * span / num))
        for i in range(num)
    ])

    rows = []
    for i, h_date in enumerate(h_dates):
        is_last     = (i == len(h_dates) - 1)
        is_judgment = is_last and is_closed

        if i == 0:
            t_ar, t_en = HEARING_TYPES[0]
        elif is_judgment:
            t_ar, t_en = HEARING_TYPES[6]
        elif is_closed and i == len(h_dates) - 2:
            t_ar, t_en = HEARING_TYPES[2]
        else:
            t_ar, t_en = random.choice(HEARING_TYPES[1:5])

        if is_judgment:
            o_ar, o_en = CLOSED_OUTCOMES[2]
        elif is_closed and i == len(h_dates) - 2:
            o_ar, o_en = CLOSED_OUTCOMES[1]
        elif is_last and not is_closed:
            o_ar, o_en = random.choice(OPEN_OUTCOMES)
        else:
            o_ar, o_en = random.choice(OPEN_OUTCOMES)

        rows.append({
            "case_id":           case_id,
            "hearing_date":      h_date,
            "hearing_type":      t_ar,
            "hearing_type_en":   t_en,
            "judge_id":          judge_id,
            "outcome":           o_ar,
            "outcome_en":        o_en,
            "next_hearing_date": h_dates[i + 1] if not is_last else None,
        })
    return rows


# ── MAIN ──────────────────────────────────────────────────────────────────────
def generate(conn):
    cur = conn.cursor()

    # ── 1. LOAD REFERENCE DATA ────────────────────────────────────────────────
    cur.execute("""
        SELECT court_id, court_name
        FROM   courts
        WHERE  court_level = 'First Instance'
        ORDER  BY court_id
    """)
    fi_courts    = cur.fetchall()
    fi_court_ids = [r[0] for r in fi_courts]

    if not fi_courts:
        raise ValueError("No First Instance courts found. Run 01_lookup_tables.sql first.")

    cur.execute("""
        SELECT ci.circuit_id, ci.court_id, ci.case_category, ci.panel_type
        FROM   circuits ci
        JOIN   courts   co ON ci.court_id = co.court_id
        WHERE  co.court_level = 'First Instance'
        ORDER  BY ci.court_id, ci.circuit_id
    """)
    circuits_by_court: dict = {}
    for cid, court_id, cat, pt in cur.fetchall():
        circuits_by_court.setdefault(court_id, []).append((cid, cat, pt))

    cur.execute("""
        SELECT judge_id, specialization, appointment_date
        FROM   judges
        WHERE  court_level = 'First Instance'
        ORDER  BY judge_id
    """)
    all_fi_judges_raw = cur.fetchall()

    if not all_fi_judges_raw:
        raise ValueError("No First Instance judges found. Run 01_lookup_tables.sql first.")

    cur.execute("SELECT status_id, status_code FROM case_statuses")
    status_map: dict = {code: sid for sid, code in cur.fetchall()}

    # ── 2. BUILD JUDGE → COURT ASSIGNMENTS ───────────────────────────────────
    court_judges: dict = {}
    assign_rows = []

    for idx, (judge_id, spec, appt_date) in enumerate(all_fi_judges_raw):
        assigned_court = fi_court_ids[idx % len(fi_court_ids)]
        court_judges.setdefault(assigned_court, []).append((judge_id, spec))

        circuit_id = None
        if spec and assigned_court in circuits_by_court:
            target_cat = SPEC_TO_CATEGORY.get(spec)
            if target_cat:
                matched = [
                    c[0] for c in circuits_by_court[assigned_court]
                    if c[1] == target_cat
                ]
                if matched:
                    circuit_id = matched[0]

        assign_rows.append((judge_id, assigned_court, circuit_id, appt_date, None, None))

    cur.executemany("""
        INSERT INTO judge_court_assignments
            (judge_id, court_id, circuit_id, assigned_from, assigned_to, role)
        VALUES (%s, %s, %s, %s, %s, %s)
        ON CONFLICT DO NOTHING
    """, assign_rows)

    all_fi_judges = [(r[0], r[1]) for r in all_fi_judges_raw]

    # ── 3. GENERATE CASES ─────────────────────────────────────────────────────
    case_seq:    dict = {}
    all_history: list = []
    all_hearings:list = []

    case_insert_sql = """
        INSERT INTO cases (
            case_number, case_year, court_id, circuit_id, judge_id, status_id,
            filing_date, first_hearing_date, judgment_date, closure_date,
            plaintiff_name, plaintiff_name_en,
            defendant_name, defendant_name_en,
            judicial_fees_amount, execution_revenue, claim_amount
        ) VALUES (
            %(case_number)s, %(case_year)s, %(court_id)s, %(circuit_id)s,
            %(judge_id)s,    %(status_id)s,
            %(filing_date)s, %(first_hearing_date)s,
            %(judgment_date)s, %(closure_date)s,
            %(plaintiff_name)s,    %(plaintiff_name_en)s,
            %(defendant_name)s,    %(defendant_name_en)s,
            %(judicial_fees_amount)s, %(execution_revenue)s, %(claim_amount)s
        ) RETURNING case_id
    """

    inserted = 0
    for _ in range(NUM_CASES):

        court_id, _ = random.choice(fi_courts)
        if not circuits_by_court.get(court_id):
            continue

        circuit_id, case_category, _ = random.choice(circuits_by_court[court_id])

        # Judge selection: specialist > generalist > any FI judge
        pool = court_judges.get(court_id, [])
        if not pool:
            pool = all_fi_judges

        specialists = [
            (jid, sp) for jid, sp in pool
            if SPEC_TO_CATEGORY.get(sp) == case_category
        ]
        generalists = [(jid, sp) for jid, sp in pool if not sp]

        if specialists:
            judge_id = random.choice(specialists)[0]
        elif generalists:
            judge_id = random.choice(generalists)[0]
        else:
            judge_id = random.choice(pool)[0]

        status_code = weighted_choice(STATUS_WEIGHTS)
        status_id   = status_map[status_code]

        filing_date        = random_date(date(2022, 1, 1), date(2024, 12, 31))
        first_hearing_date = filing_date + timedelta(days=random.randint(14, 45))
        judgment_date      = None
        closure_date       = None

        if status_code in CLOSED_STATUSES:
            duration      = random.randint(30, 730)
            judgment_date = first_hearing_date + timedelta(days=duration)
            closure_date  = judgment_date + timedelta(days=random.randint(1, 14))
            today = date.today()
            if closure_date > today:
                closure_date  = today - timedelta(days=1)
                judgment_date = closure_date - timedelta(days=random.randint(1, 7))

        # Guaranteed-unique case number: YEAR/SEQ/C{court_id}
        year = filing_date.year
        key  = (court_id, year)
        case_seq[key] = case_seq.get(key, 0) + 1
        case_number   = f"{year}/{case_seq[key]:04d}/C{court_id}"

        idx_p = random.randint(0, len(PLAINTIFF_AR) - 1)
        idx_d = random.randint(0, len(DEFENDANT_AR) - 1)
        attempts = 0
        while idx_d == idx_p and attempts < 10:
            idx_d = random.randint(0, len(DEFENDANT_AR) - 1)
            attempts += 1

        fee_lo,   fee_hi   = FEES_BY_CATEGORY.get(case_category, (20, 500))
        claim_lo, claim_hi = CLAIM_BY_CATEGORY.get(case_category, (0, 0))

        judicial_fees = round(random.uniform(fee_lo, fee_hi), 3)
        claim_amount  = (
            round(random.uniform(claim_lo, claim_hi), 3)
            if claim_hi > 0 else None
        )
        exec_revenue = None
        if case_category in ("Criminal", "Commercial") and status_code == "JUDGED":
            exec_revenue = round(random.uniform(100, 10000), 3)

        row = {
            "case_number":          case_number,
            "case_year":            year,
            "court_id":             court_id,
            "circuit_id":           circuit_id,
            "judge_id":             judge_id,
            "status_id":            status_id,
            "filing_date":          filing_date,
            "first_hearing_date":   first_hearing_date,
            "judgment_date":        judgment_date,
            "closure_date":         closure_date,
            "plaintiff_name":       PLAINTIFF_AR[idx_p],
            "plaintiff_name_en":    PLAINTIFF_EN[idx_p],
            "defendant_name":       DEFENDANT_AR[idx_d],
            "defendant_name_en":    DEFENDANT_EN[idx_d],
            "judicial_fees_amount": judicial_fees,
            "execution_revenue":    exec_revenue,
            "claim_amount":         claim_amount,
        }
        cur.execute(case_insert_sql, row)
        case_id = cur.fetchone()[0]
        inserted += 1

        all_history.extend(build_status_history(
            case_id, status_code,
            filing_date, first_hearing_date,
            closure_date, status_map,
        ))
        all_hearings.extend(build_hearings(
            case_id, judge_id, status_code,
            first_hearing_date, judgment_date, closure_date,
        ))

    # ── 4. BULK INSERTS ───────────────────────────────────────────────────────
    if all_hearings:
        cur.executemany("""
            INSERT INTO hearings (
                case_id, hearing_date, hearing_type, hearing_type_en,
                judge_id, outcome, outcome_en, next_hearing_date
            ) VALUES (
                %(case_id)s, %(hearing_date)s, %(hearing_type)s, %(hearing_type_en)s,
                %(judge_id)s, %(outcome)s, %(outcome_en)s, %(next_hearing_date)s
            )
        """, all_hearings)

    if all_history:
        cur.executemany("""
            INSERT INTO case_status_history
                (case_id, status_id, changed_at, changed_by)
            VALUES (%s, %s, %s, 'system')
        """, all_history)

    conn.commit()

    # ── 5. VERIFICATION ───────────────────────────────────────────────────────
    cur.execute("SELECT COUNT(*), COUNT(DISTINCT case_number) FROM cases")
    total, distinct = cur.fetchone()
    cur.close()

    print(f"\n✅  Cases inserted          : {inserted}")
    print(f"✅  Hearings inserted        : {len(all_hearings)}")
    print(f"✅  Status history rows      : {len(all_history)}")
    print(f"✅  Judge assignments        : {len(assign_rows)}")
    if total == distinct:
        print(f"✅  All {total} case numbers are unique")
    else:
        print(f"⚠️  Duplicate case numbers! total={total}, distinct={distinct}")


# ── ENTRY POINT ───────────────────────────────────────────────────────────────
if __name__ == "__main__":
    conn = psycopg2.connect(**DB_CONFIG)
    try:
        generate(conn)
    except Exception as e:
        conn.rollback()
        print(f"❌ Error: {e}")
        raise
    finally:
        conn.close()
