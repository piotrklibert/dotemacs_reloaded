import re
from time import time
from path import path as P
from whoosh.index import open_dir
from whoosh.query import Regex

index = open_dir("./idx")
from time import time

<<<<<<< HEAD
t = time()
with index.searcher() as s:
    results = s.search(Regex("content", "^class$"), limit=None)
    for result in results:
        if not result["content"].startswith("class"):
            continue
        p = P(result["path"])
        # print "/".join(p.splitall()[-3:]),
        # print result["line"], result["content"][:-2]

print time() - t
=======

def search(term):
    with index.searcher() as s:
        results = s.search(Regex("content", term), limit=None)
        regexp = re.compile(term)

        for result in results:
            if not regexp.search(result["content"]):
                print ",",
                continue
            p = P(result["path"])
            print "/".join(p.splitall()[-3:]),
            print result["line"], result["content"][:-1]



if __name__ == "__main__":
    t = time()
    import sys
    search(sys.argv[1])
    print time() - t
>>>>>>> 4b90aeb742603d62a7f456b48c99522da5904289
