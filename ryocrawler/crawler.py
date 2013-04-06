#!/usr/bin/env python
import os
import re
import urlparse
import urllib2
import re
import sys
import time
import math
import urllib2
import urllib
import httplib
import urlparse
import optparse
from cgi import escape
from traceback import format_exc
from Queue import Queue, Empty as QueueEmpty
from BeautifulSoup import BeautifulSoup
import logging
import wascanner


__version__ = "0.2"
__copyright__ = "CopyRight (C) 2008-2011 code is heavily based on http://code.activestate.com/recipes/576551-simple-web-crawler/ by James Mills"
__license__ = "MIT"
__author__ = "James Mills. o0o.nu mods"
__author_email__ = "James Mills. o0o.nu"


AGENT = "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E)"

#
# TODO: Roll it distributed with celery
#

class Crawler(object):

    def __init__(self, root, depth, domain, locked=True):
        self.root = root
        self.depth = depth
        self.domain = domain
        self.locked = locked
        self.host = urlparse.urlparse(root)[1]
        self.urls = []
        self.visited = []
        self.links = 0
        self.followed = 0
        self.scanner = wascanner.Scanner()
        self.matches = {}

    def _fil(s):
        return "".join(filter(lambda x: ord(x)<128, s))

    def scope(self, url):
        if re.search(".*%s" %self.domain, url):
            return True
        return False
    def scan(self, url, content):
        r = self.scanner.scan(_fil(content))
        if len(r) > 0:
            self.matches[url] = r

    def crawl(self):
        page = Fetcher(self.root)
        page.fetch()
        self.scan(page.url, page.content)
        q = Queue()
        for url in page.urls:
            if self.scope(url):
                q.put(_fil(url))
        self.visited = [self.root]

        n = 0
        if q.qsize() == 0:
            return # no urls to follow

        while True:
            try:
                url = q.get()
            except QueueEmpty:
                break

            n += 1

            if url not in self.visited:
                try:
                    host = urlparse.urlparse(url)[1]
                    if self.scope(host):
                        self.visited.append(url)
                        self.followed += 1
                        page = Fetcher(url)
                        page.fetch()
                        self.scan(page.url, page.content)
                        for i, url in enumerate(page):
                            if url not in self.urls:
                                self.links += 1
                                q.put(_fil(url))
                                self.urls.append(_fil(url))
                        if n > self.depth and self.depth > 0:
                            break
                except Exception, e:
                    print "ERROR: Can't process url '%s' (%s)" % (url, e)
                    print format_exc()
        return

class Fetcher(object):

    def __init__(self, url):
        self.url = url
        self.content = ""
        self.urls = []

    def __getitem__(self, x):
        return self.urls[x]

    def _addHeaders(self, request):
        request.add_header("User-Agent", AGENT)

    def open(self):
        url = self.url
        try:
            request = urllib2.Request(url)
            handle = urllib2.build_opener()
        except IOError:
            return None
        return (request, handle)

    def fetch(self):
        request, handle = self.open()
        self._addHeaders(request)
        if handle:
            try:
                self.content = unicode(handle.open(request).read(), "utf-8",
                        errors="replace")
                self.soup = BeautifulSoup(self.content)
                tags = self.soup('a')
                refresh = self.soup.find("meta", attrs = {"http-equiv": "refresh"})

            except urllib2.HTTPError, error:
                if error.code == 404:
                    print >> sys.stderr, "ERROR: %s -> %s" % (error, error.url)
                else:
                    print >> sys.stderr, "ERROR: %s" % error
                tags = []
                refresh = []
            except urllib2.URLError, error:
                print >> sys.stderr, "ERROR: %s" % error
                tags = []
                refresh = []
# regular href tags
            for tag in tags:
                href = tag.get("href")
                if href is not None:
                    url = urlparse.urljoin(self.url, escape(href))
                    if url not in self:
                        self.urls.append(url)
            if refresh:
                wait,text = refresh["content"].split(";")
                if text.replace(" ","").lower().startswith("url="):
                    url = urlparse.urljoin(self.url, escape(text.replace(" ", "")[4:]))
                    if url not in self:
                        self.urls.append(url)

def getLinks(url):
    page = Fetcher(url)
    page.fetch()
    for i, url in enumerate(page):
        print "%d. %s" % (i, url)

def _fil(s):
    return "".join(filter(lambda x: ord(x)<128, s))

def submit_report(url, report, status):

    print "%s %s" %  (url, status)
    print report


def crawl(tocrawl_url, depth, logger):
    domain = urlparse.urlparse(tocrawl_url).hostname.replace("www.","")
    print "Crawling under domain: %s" %(domain)

    sTime = time.time()
    crawler = Crawler(tocrawl_url, depth, domain)
    crawler.crawl()
    status = "clean"
    eTime = time.time()
    tTime = eTime - sTime
    report  = "target: %s domain: %s stats: (%d/s after %0.2fs)<hr>" % (tocrawl_url, domain, int(math.ceil(float(crawler.links)/tTime)), tTime )

    # if we had any match... then something is bad :)

    if len(crawler.matches) > 0:
        status = "malicious"
        for u in crawler.matches.keys():
            for match in crawler.matches[u]:
                report = "%s<br>URL: %s <font color=\"red\">detected</font>: %s<br>" % (report, u, match)

    report  = "%s <hr> found urls: %d followed urls: %d<br>Visited urls:<br><ul>" % (report, crawler.followed, crawler.links)
    for u in crawler.visited:
        if re.search(".*%s"%domain, u):
            report = "%s<li><a href=\"%s\">%s</a></li>" % (report, u, u)
    report = "%s</ul><hr>Discovered urls:<ul>" %(report)
    for u in crawler.urls:
        if re.search(".*%s"%domain, u):
            report = "%s<li><a href=\"%s\">%s</a></li>" % (report, u, u)
    report = "%s</ul>" %(report)
    submit_report (tocrawl_url, report, status)


def ex(url):
    l = logging.getLogger()
    l.info("starting %s" % (url))
    crawl(url, 200, l)
    try:
        print "done"
    except Exception, e:
        print e
        report = "target: %s failed. %s" % (url, e)
        submit_report(url, report, "failed")


if __name__ == "__main__":
    import sys
    ex((sys.argv[1]))

