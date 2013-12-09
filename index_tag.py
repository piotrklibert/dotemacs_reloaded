from time import time
from path import path as P
from whoosh.fields import ID, NUMERIC, TEXT, Schema
from whoosh.index import create_in

schema = Schema(path=ID(stored=True), line=NUMERIC(stored=True),  content=TEXT(stored=True))
index = create_in("./idx", schema)

def standalone_js(path):
    b, d = path.basename(), path.parent
    return bool(d.files(b + ".coffee"))

def migration(path):
    return "migrations" in path.splitall()

writer = index.writer()
c = 0
for path in P("/usr/www/tagasauris/tagasauris/").walkfiles():
    c += 1
    ext = path.ext
    if ext == ".py" or ext == ".coffee" or standalone_js(path) :
        if  migration(path):
            continue

        t1 = time()
        for n, line in enumerate(path.lines("utf8")):
            writer.add_document(
                line=n,
                content=line,
                path=path.decode(),
            )
        t2 = time()
        if c % 70 == 0:
            writer.commit()
            writer = index.writer()

        print "added %s in %s" % (path, t2 - t1)

writer.commit()
