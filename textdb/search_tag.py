import sys
import sqlite3 as db


def main():
    con = db.connect("index.db")
    cur = con.cursor()

    while True:
        v = raw_input().strip()
        if v.lower().startswith("----"):
            break
        Q = "SELECT * FROM lines WHERE line LIKE ? LIMIT 50"
        cur.execute(Q, [v])
        res = cur.fetchall()
        [sys.stdout.write("{0},{1} - {2}\n".format(*x)) for x in res]
        sys.stdout.flush()


if __name__ == "__main__":
    main()
