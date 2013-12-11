import re
from time import time
from path import path as P
from whoosh.index import open_dir
from whoosh.query import Regex

index = open_dir("./idx")


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
