from path import path as P
from whoosh.index import open_dir
from whoosh.query import Regex

index = open_dir("./idx")

with index.searcher() as s:
    results = s.search(Regex("content", "^class$"), limit=None)
    for result in results:
        if not result["content"].startswith("class"):
            continue
        p = P(result["path"])
        # print "/".join(p.splitall()[-3:]),
        # print result["line"], result["content"][:-2]
