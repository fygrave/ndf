#!/usr/bin/env python
import yara
import os
import crawler
import sys

sys.path.append( "%s/deps" % (os.path.dirname(os.path.realpath(__file__))))

import jsunpack




class Scanner(object):
    class Opts:
        rules = ""
        rulesAscii = ""
        active = True
        veryverbose = True
        verbose = True
        outdir = "/tmp"
        tmpdir = "/tmp"
        currentproxy = ''
        nojs = False
        fasteval = False
        redoevaltime = 10
        htmlparse = False
        timeout = 60
        proxy = None
        htmlparseconfig = ""
        interface = None
        urlfetch = None
        pre = "pre.js"
        maxruntime = 10
        post = "post.js"
        quiet = False
        saveallfiles = True
        debug = False
    jsunpackopts = Opts()

    def __init__(self):
        self.yara = yara.compile("%s/yara/web.yar" % os.path.dirname(os.path.realpath(__file__)))

    def _fil(self, s):
        return "".join(filter(lambda x: ord(x)<128, s))

    def scan(self, data, url):
        rez = []
        js = jsunpack.jsunpackn.jsunpack(url, ['', data.encode('utf-8'), url],  self.jsunpackopts )

        for url in js.rooturl:
            js.rooturl[url].seen = {}

        if js.start in js.rooturl:
            tmp = js.rooturl[js.start].tostring('', True)[0]
            print tmp
            print js.rooturl[js.start].malicious
            rez.append(tmp)
            #print tmp

        y = self.yara.match(data=self._fil(data))
        if len(y) != 0 and y != "[]":
            print "Detected"
            print y
            rez.append(y)
        return rez

# mainly for testing
def ex(url):
    f = crawler.Fetcher(url)
    f.fetch()
    s = Scanner()
    r = s.scan(f.content, f.url)
    print r


if __name__ == "__main__":
    import sys
    ex((sys.argv[1]))

