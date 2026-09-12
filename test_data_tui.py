"""
CrisisConnect test data TUI.

Connects straight to the local Postgres database (reads connection details
from CrisisConnect-Backend/.env, next to this script) and lets you create
volunteer applications and donations for testing the NGO applicant/donation
review pages -- without needing a real Volunteer signup/login (tedious) or
a real Donor one (the Donor backend is still a stub with no working
signup/donate endpoint at all).

This talks to the database directly. It is a local dev/testing tool only --
never point it at anything but your own local dev database, and never
commit real data through it.

Setup:
    pip install psycopg2-binary

Run:
    python test_data_tui.py

Menu:
    1) Quick demo action -- the fast path for a live viva/demo: pick an NGO,
       pick a joined crisis (skipped automatically if there's only one), then
       just click "Make an application" or "Make a donation". Every field
       (volunteer/donor name, message, amount) is auto-filled with dummy
       values -- nothing to type while your examiner is watching. "b" goes
       back a step at any point (e.g. to switch to another NGO) instead of
       having to restart the script.
    2) Manual tools -- the original one-field-at-a-time menu, kept for
       ad-hoc DB poking (listing tables, creating a test donor by hand, etc).
"""

import sys
from pathlib import Path

try:
    import psycopg2
    import psycopg2.extras
except ImportError:
    print("Missing dependency. Run: pip install psycopg2-binary")
    sys.exit(1)

ROOT = Path(__file__).resolve().parent
ENV_PATH = ROOT / "CrisisConnect-Backend" / ".env"

DUMMY_MESSAGE = "test"
DUMMY_DONATION_AMOUNT = "500.00"
DUMMY_VOLUNTEER_NAME = "ABC Volunteer"
DUMMY_DONOR_NAME = "XYZ Donor"


def load_env(path):
    env = {}
    with open(path, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#") or "=" not in line:
                continue
            key, value = line.split("=", 1)
            env[key.strip()] = value.strip()
    return env


def connect():
    if not ENV_PATH.exists():
        print(f"Could not find {ENV_PATH}")
        sys.exit(1)

    env = load_env(ENV_PATH)
    return psycopg2.connect(
        host=env.get("DB_HOST", "localhost"),
        port=env.get("DB_PORT", "5432"),
        user=env.get("DB_USERNAME"),
        password=env.get("DB_PASSWORD"),
        dbname=env.get("DB_NAME"),
        cursor_factory=psycopg2.extras.RealDictCursor,
    )


def print_rows(rows, columns):
    if not rows:
        print("  (none)")
        return
    for row in rows:
        print("  " + " | ".join(f"{col}={row[col]}" for col in columns))


# ---------------------------------------------------------------------------
# Quick demo action -- fast, mostly-no-typing path for live demos.
# ---------------------------------------------------------------------------


def choose(items, title, label_fn):
    """Numbered picker. Returns the chosen item, or None on 'b' (back)."""
    while True:
        print(f"\n{title}")
        for i, item in enumerate(items, start=1):
            print(f"  {i}) {label_fn(item)}")
        print("  b) Back")
        print("  q) Quit")
        choice = input("Choice: ").strip().lower()
        if choice == "q":
            print("Bye.")
            sys.exit(0)
        if choice == "b":
            return None
        if choice.isdigit() and 1 <= int(choice) <= len(items):
            return items[int(choice) - 1]
        print("Not a valid choice.")


def fetch_ngos(conn):
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT n.id, n."orgName", n.city, u."createdAt"
            FROM ngo n
            JOIN "user" u ON u.id = n."userId"
            ORDER BY u."createdAt" DESC
            """
        )
        return cur.fetchall()


def fetch_joined_crises(conn, ngo_id):
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT c.id, c.title
            FROM crisis_participation cp
            JOIN crisis c ON c.id = cp."crisisId"
            WHERE cp."ngoId" = %s
            ORDER BY c.id
            """,
            (ngo_id,),
        )
        return cur.fetchall()


def fetch_volunteer_calls(conn, ngo_id, crisis_id):
    with conn.cursor() as cur:
        cur.execute(
            'SELECT id, title FROM volunteer_call WHERE "ngoId" = %s AND "crisisId" = %s ORDER BY id',
            (ngo_id, crisis_id),
        )
        return cur.fetchall()


def fetch_donation_calls(conn, ngo_id, crisis_id):
    with conn.cursor() as cur:
        cur.execute(
            'SELECT id, title FROM donation_call WHERE "ngoId" = %s AND "crisisId" = %s ORDER BY id',
            (ngo_id, crisis_id),
        )
        return cur.fetchall()


def pick_call(conn, calls, kind_label):
    """calls is already the exact (ngo, crisis) list. Skips the prompt when
    there's exactly one, same as the crisis-selection rule."""
    if not calls:
        return None
    if len(calls) == 1:
        return calls[0]
    return choose(calls, f"Select {kind_label}:", lambda c: c["title"])


def create_dummy_volunteer(conn, city):
    with conn.cursor() as cur:
        cur.execute("SELECT extract(epoch from now())::bigint AS ts")
        ts = cur.fetchone()["ts"]
        email = f"demo.volunteer.{ts}@example.com"
        username = f"demo_volunteer_{ts}"

        cur.execute(
            """
            INSERT INTO "user" (email, "passwordHash", role, "isVerified", "isActive")
            VALUES (%s, 'TEST_DATA_NO_REAL_LOGIN', 'VOLUNTEER', true, true)
            RETURNING id
            """,
            (email,),
        )
        user_id = cur.fetchone()["id"]

        cur.execute(
            """
            INSERT INTO volunteer (username, email, password, "fullName", phone, city, "userId")
            VALUES (%s, %s, 'TEST_DATA_NO_REAL_LOGIN', %s, 1700000000, %s, %s)
            RETURNING id
            """,
            (username, email, DUMMY_VOLUNTEER_NAME, city, user_id),
        )
        volunteer_id = cur.fetchone()["id"]
        conn.commit()
        return volunteer_id


def create_dummy_donor(conn, city):
    with conn.cursor() as cur:
        cur.execute("SELECT extract(epoch from now())::bigint AS ts")
        ts = cur.fetchone()["ts"]
        email = f"demo.donor.{ts}@example.com"
        unique_id = f"DEMO-DONOR-{ts}"

        cur.execute(
            """
            INSERT INTO "user" (email, "passwordHash", role, "isVerified", "isActive")
            VALUES (%s, 'TEST_DATA_NO_REAL_LOGIN', 'DONOR', true, true)
            RETURNING id
            """,
            (email,),
        )
        user_id = cur.fetchone()["id"]

        cur.execute(
            """
            INSERT INTO donor ("uniqueId", "fullName", city, country, "joiningDate", "userId")
            VALUES (%s, %s, %s, 'Bangladesh', now(), %s)
            RETURNING id
            """,
            (unique_id, DUMMY_DONOR_NAME, city, user_id),
        )
        donor_id = cur.fetchone()["id"]
        conn.commit()
        return donor_id


def quick_application(conn, ngo, crisis):
    calls = fetch_volunteer_calls(conn, ngo["id"], crisis["id"])
    call = pick_call(conn, calls, "volunteer call")
    if not calls:
        print(f"'{ngo['orgName']}' has no volunteer call under '{crisis['title']}' yet -- nothing to apply to.")
        return
    if call is None:
        return

    volunteer_id = create_dummy_volunteer(conn, ngo["city"])
    with conn.cursor() as cur:
        cur.execute(
            """
            INSERT INTO application (message, status, "appliedAt", "volunteerId", "volunteerCallId")
            VALUES (%s, 'PENDING', now(), %s, %s)
            RETURNING id
            """,
            (DUMMY_MESSAGE, volunteer_id, call["id"]),
        )
        app_id = cur.fetchone()["id"]
        conn.commit()
        print(f"Done -- '{DUMMY_VOLUNTEER_NAME}' applied to '{call['title']}' (application id={app_id}, status=PENDING).")


def quick_donation(conn, ngo, crisis):
    calls = fetch_donation_calls(conn, ngo["id"], crisis["id"])
    call = pick_call(conn, calls, "donation call")
    if not calls:
        print(f"'{ngo['orgName']}' has no donation call under '{crisis['title']}' yet.")
        return
    if call is None:
        return

    donor_id = create_dummy_donor(conn, ngo["city"])
    with conn.cursor() as cur:
        cur.execute(
            """
            INSERT INTO donation (amount, message, status, "createdAt", "donorId", "donationCallId")
            VALUES (%s, %s, 'PAID', now(), %s, %s)
            RETURNING id
            """,
            (DUMMY_DONATION_AMOUNT, DUMMY_MESSAGE, donor_id, call["id"]),
        )
        donation_id = cur.fetchone()["id"]

        # raisedAmount is a plain stored column -- nothing recomputes it
        # automatically, so bump it the same way the real Donor flow would.
        cur.execute(
            'UPDATE donation_call SET "raisedAmount" = "raisedAmount" + %s WHERE id = %s',
            (DUMMY_DONATION_AMOUNT, call["id"]),
        )
        conn.commit()
        print(f"Done -- '{DUMMY_DONOR_NAME}' donated {DUMMY_DONATION_AMOUNT} to '{call['title']}' (donation id={donation_id}, status=PAID).")


def quick_demo(conn):
    while True:  # NGO selection
        ngos = fetch_ngos(conn)
        if not ngos:
            print("No NGOs in the database.")
            return
        ngo = choose(
            ngos,
            "Select NGO (newest registered first):",
            lambda n: f"{n['orgName']} -- {n['city']} (id {n['id']}, registered {n['createdAt']:%Y-%m-%d %H:%M})",
        )
        if ngo is None:
            return  # back to main menu

        while True:  # crisis selection for this NGO
            crises = fetch_joined_crises(conn, ngo["id"])
            if not crises:
                print(f"'{ngo['orgName']}' hasn't joined any crisis yet.")
                break  # back to NGO selection

            only_one_crisis = len(crises) == 1
            if only_one_crisis:
                crisis = crises[0]
                print(f"\nOnly one joined crisis -- using '{crisis['title']}'.")
            else:
                crisis = choose(crises, f"Select crisis joined by '{ngo['orgName']}':", lambda c: c["title"])
                if crisis is None:
                    break  # back to NGO selection

            while True:  # action menu for this (ngo, crisis)
                action = choose(
                    ["Make an application", "Make a donation"],
                    f"NGO: {ngo['orgName']}  |  Crisis: {crisis['title']}",
                    lambda a: a,
                )
                if action is None:
                    break  # back to crisis selection (or NGO selection, see below)
                if action == "Make an application":
                    quick_application(conn, ngo, crisis)
                else:
                    quick_donation(conn, ngo, crisis)

            if only_one_crisis:
                break  # no crisis menu to return to -- go straight back to NGO selection


# ---------------------------------------------------------------------------
# Manual tools -- original one-field-at-a-time menu, kept for ad-hoc DB work.
# ---------------------------------------------------------------------------


def list_volunteers(conn):
    with conn.cursor() as cur:
        cur.execute(
            'SELECT id, username, "fullName", city FROM volunteer ORDER BY id'
        )
        print_rows(cur.fetchall(), ["id", "username", "fullName", "city"])


def list_volunteer_calls(conn):
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT vc.id, vc.title, vc.status, vc.city, n."orgName"
            FROM volunteer_call vc
            JOIN ngo n ON n.id = vc."ngoId"
            ORDER BY vc.id
            """
        )
        print_rows(cur.fetchall(), ["id", "title", "status", "city", "orgName"])


def list_applications(conn):
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT a.id, v."fullName" AS volunteer, vc.title AS call, a.status, a."appliedAt"
            FROM application a
            JOIN volunteer v ON v.id = a."volunteerId"
            JOIN volunteer_call vc ON vc.id = a."volunteerCallId"
            ORDER BY a.id
            """
        )
        print_rows(cur.fetchall(), ["id", "volunteer", "call", "status", "appliedAt"])


def create_application(conn):
    list_volunteers(conn)
    volunteer_id = input("Volunteer id: ").strip()
    list_volunteer_calls(conn)
    call_id = input("Volunteer call id: ").strip()
    message = input("Application message: ").strip() or "I'd like to help with this."

    with conn.cursor() as cur:
        cur.execute(
            'SELECT id FROM volunteer WHERE id = %s', (volunteer_id,)
        )
        if cur.fetchone() is None:
            print("No such volunteer.")
            return

        cur.execute(
            'SELECT id FROM volunteer_call WHERE id = %s', (call_id,)
        )
        if cur.fetchone() is None:
            print("No such volunteer call.")
            return

        cur.execute(
            'SELECT id FROM application WHERE "volunteerId" = %s AND "volunteerCallId" = %s',
            (volunteer_id, call_id),
        )
        if cur.fetchone() is not None:
            print("This volunteer already applied to this call.")
            return

        cur.execute(
            """
            INSERT INTO application (message, status, "appliedAt", "volunteerId", "volunteerCallId")
            VALUES (%s, 'PENDING', now(), %s, %s)
            RETURNING id
            """,
            (message, volunteer_id, call_id),
        )
        new_id = cur.fetchone()["id"]
        conn.commit()
        print(f"Created application id={new_id}, status=PENDING.")


def list_donors(conn):
    with conn.cursor() as cur:
        cur.execute(
            'SELECT id, "fullName", "uniqueId", city FROM donor ORDER BY id'
        )
        print_rows(cur.fetchall(), ["id", "fullName", "uniqueId", "city"])


def create_donor(conn):
    # The Donor backend is still a stub with no real signup endpoint, so
    # there is no way to get a donor row into the database except this.
    # A donor needs both a user row (role=DONOR) and a donor row, 1:1.
    full_name = input("Full name: ").strip() or "Test Donor"
    city = input("City: ").strip() or "Dhaka"
    country = input("Country [Bangladesh]: ").strip() or "Bangladesh"

    with conn.cursor() as cur:
        cur.execute("SELECT extract(epoch from now())::bigint AS ts")
        ts = cur.fetchone()["ts"]
        email = f"test.donor.{ts}@example.com"
        unique_id = f"DONOR-{ts}"

        cur.execute(
            """
            INSERT INTO "user" (email, "passwordHash", role, "isVerified", "isActive")
            VALUES (%s, 'TEST_DATA_NO_REAL_LOGIN', 'DONOR', true, true)
            RETURNING id
            """,
            (email,),
        )
        user_id = cur.fetchone()["id"]

        cur.execute(
            """
            INSERT INTO donor ("uniqueId", "fullName", city, country, "joiningDate", "userId")
            VALUES (%s, %s, %s, %s, now(), %s)
            RETURNING id
            """,
            (unique_id, full_name, city, country, user_id),
        )
        donor_id = cur.fetchone()["id"]
        conn.commit()
        print(f"Created donor id={donor_id} ({full_name}). This donor can't log in for real -- test data only.")


def list_donation_calls(conn):
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT dc.id, dc.title, dc.status, dc."raisedAmount", dc."targetAmount", n."orgName"
            FROM donation_call dc
            JOIN ngo n ON n.id = dc."ngoId"
            ORDER BY dc.id
            """
        )
        print_rows(
            cur.fetchall(),
            ["id", "title", "status", "raisedAmount", "targetAmount", "orgName"],
        )


def list_donations(conn):
    with conn.cursor() as cur:
        cur.execute(
            """
            SELECT d.id, don."fullName" AS donor, dc.title AS call, d.amount, d.status, d."createdAt"
            FROM donation d
            JOIN donor don ON don.id = d."donorId"
            JOIN donation_call dc ON dc.id = d."donationCallId"
            ORDER BY d.id
            """
        )
        print_rows(cur.fetchall(), ["id", "donor", "call", "amount", "status", "createdAt"])


def create_donation(conn):
    list_donors(conn)
    donor_id = input("Donor id: ").strip()
    list_donation_calls(conn)
    call_id = input("Donation call id: ").strip()
    amount = input("Amount (e.g. 500.00): ").strip()
    message = input("Message (optional): ").strip() or "Happy to help."

    with conn.cursor() as cur:
        cur.execute('SELECT id FROM donor WHERE id = %s', (donor_id,))
        if cur.fetchone() is None:
            print("No such donor.")
            return

        cur.execute('SELECT id FROM donation_call WHERE id = %s', (call_id,))
        if cur.fetchone() is None:
            print("No such donation call.")
            return

        try:
            float(amount)
        except ValueError:
            print("Amount must be a number.")
            return

        cur.execute(
            """
            INSERT INTO donation (amount, message, status, "createdAt", "donorId", "donationCallId")
            VALUES (%s, %s, 'PAID', now(), %s, %s)
            RETURNING id
            """,
            (amount, message, donor_id, call_id),
        )
        new_id = cur.fetchone()["id"]

        # The real Donor flow (once built) would do this too -- raisedAmount
        # is a plain stored column, nothing recomputes it automatically.
        cur.execute(
            'UPDATE donation_call SET "raisedAmount" = "raisedAmount" + %s WHERE id = %s',
            (amount, call_id),
        )
        conn.commit()
        print(f"Created donation id={new_id}, status=PAID. raisedAmount updated.")


MANUAL_MENU = """
Manual tools
1) List volunteers
2) List volunteer calls
3) Create an application
4) List applications
5) List donors
6) List donation calls
7) Create a donation
8) List donations
9) Create a test donor (Donor backend is a stub -- no real signup exists)
0) Back
"""


def manual_menu(conn):
    while True:
        print(MANUAL_MENU)
        choice = input("Choice: ").strip()
        if choice == "1":
            list_volunteers(conn)
        elif choice == "2":
            list_volunteer_calls(conn)
        elif choice == "3":
            create_application(conn)
        elif choice == "4":
            list_applications(conn)
        elif choice == "5":
            list_donors(conn)
        elif choice == "6":
            list_donation_calls(conn)
        elif choice == "7":
            create_donation(conn)
        elif choice == "8":
            list_donations(conn)
        elif choice == "9":
            create_donor(conn)
        elif choice == "0":
            return
        else:
            print("Not a valid choice.")


MAIN_MENU = """
CrisisConnect test data
1) Quick demo action (fast: pick NGO, pick crisis if needed, make an application or donation)
2) Manual tools (browse tables, create a test donor by hand)
0) Exit
"""


def main():
    conn = connect()
    print("Connected.")
    try:
        while True:
            print(MAIN_MENU)
            choice = input("Choice: ").strip()
            if choice == "1":
                quick_demo(conn)
            elif choice == "2":
                manual_menu(conn)
            elif choice == "0":
                break
            else:
                print("Not a valid choice.")
    finally:
        conn.close()


if __name__ == "__main__":
    main()
