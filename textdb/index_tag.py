import sqlite3 as db

from path import path as P


def standalone_js(path):
    b, d = path.basename(), path.parent
    return bool(d.files(b + ".coffee"))

def migration(path):
    return "migrations" in path.splitall()


con = db.connect("index.db")
cur = con.cursor()


c = 0
for path in P("/usr/www/tagasauris/tagasauris/").walkfiles():
    c += 1
    ext = path.ext
    if ext == ".py" or ext == ".coffee" or standalone_js(path) :
        if  migration(path):
            continue

        for n, line in enumerate(path.lines("utf8")):
            line = line.strip()
            if line:
                cur.execute("INSERT INTO lines VALUES (?, ?, ?)", [path, n, line])

        print "added {}".format(path)

con.commit()
