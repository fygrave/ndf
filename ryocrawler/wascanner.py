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
        self.yara = yara.compile("%s/yara/web.yar" % os.path.dirname(os.path.realpath(__file__)))

    def _fil(self, s):
        return "".join(filter(lambda x: ord(x)<128, s))

    def scan(self, data):
    #    js = jsunpack.jsunpackn.jsunpack("/tmp/a", ['', data, "/tmp/a"], self.jsunpackopts)
    #    print js
        rez = []
        y = self.yara.match(data=self._fil(data))
        if len(y) != 0 and y != "[]":
            print "Detected"
            print y
        return y

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

