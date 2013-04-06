#!/usr/bin/env python
import yara
import os
import crawler
import sys

sys.path.append( "%s/deps" % (os.path.dirname(os.path.realpath(__file__))))

import jsunpack




class Scanner(object):
    jsunpackopts = {"active": True}

    def __init__(self):
        self.yara = yara.load_rules(rules_rootpath = "%s/yara" % os.path.dirname(os.path.realpath(__file__)))

    def _fil(self, s):
        return "".join(filter(lambda x: ord(x)<128, s))

    def scan(self, data):
    #    js = jsunpack.jsunpackn.jsunpack("/tmp/a", ['', data, "/tmp/a"], self.jsunpackopts)
    #    print js
        rez = []
        y = self.yara.match_data(self._fil(data))
        for m in y.keys():
            for item in y[m]:
                if item["matches"]:
                    rez.append(item["rule"])
        #print rez
        return rez

# mainly for testing
def ex(url):
    f = crawler.Fetcher(url)
    f.fetch()
    s = Scanner()
    r = s.scan(f.content)
    print r


if __name__ == "__main__":
    import sys
    ex((sys.argv[1]))

