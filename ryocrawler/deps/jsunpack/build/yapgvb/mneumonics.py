# 
# This file is a part of the Yapgvb software package, and is 
# licensed under the New BSD license.
# A `LICENSE' file should have been included with this source.
#
# Copyright (c) 2009 Lonnie Princehouse
#

class _collection(dict):
    def __init__(self, **keywords):
        dict.__init__(self)
        for k,v in keywords.iteritems():
            self[k] = v
            setattr(self, k, v)

engines = _collection ( 
    circo   = 'circo',
    dot     = 'dot',
    fdp     = 'fdp',
    neato   = 'neato',
    twopi   = 'twopi',
    )

colors = _collection (
    red     = 'red',
    orange  = 'orange',
    yellow  = 'yellow',
    green   = 'green',
    blue    = 'blue',
    indigo  = 'indigo',
    violet  = 'violet'
    )

formats = _collection (**dict([(x,x) for x in 'canoncmap cmapx dia dot fig gd gd2 gif hpgl imap ismap jpeg jpg mif mp pcl pic plain plain-ext png ps ps2 svg svgz vrml vtx wbmp xdot'.split()]))

