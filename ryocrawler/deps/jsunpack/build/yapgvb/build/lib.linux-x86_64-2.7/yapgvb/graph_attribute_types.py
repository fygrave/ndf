# 
# This file is a part of the Yapgvb software package, and is 
# licensed under the New BSD License.
# A `LICENSE' file should have been included with this source.
#
# Copyright (c) 2009 Lonnie Princehouse
#


def identity(x) : return x

class AttributeType(object):
    def __init__(self, gv_to_python, python_to_gv, bgl_type='object', doc_type=None, epydocstr=None):
        self._gv_to_python = gv_to_python
        self._python_to_gv = python_to_gv
        self.bgl_type = bgl_type 
        self.__epydoc_str__ = epydocstr
        if doc_type is not None:
            self.__epydoc_type__ = doc_type # used only for auto-generating documentation

    def __iter__(self):
        yield self._gv_to_python
        yield self._python_to_gv

    def epydoc_type(self):
        try:
            return self.__epydoc_type__
        except:
            return self.bgl_type

    def epydoc_doc(self):
        try:
            return self.__epydoc_str__
        except:
            return None

class enum(dict, AttributeType):
    def __init__(self, (gv_to_python, python_to_gv), values, bgl_type='object', doc_type=None, epydocstr=None):
        dict.__init__(self)
        AttributeType.__init__(self, gv_to_python, python_to_gv, bgl_type, doc_type, epydocstr)
        self.__values__ = values
        for v in values:
            setattr(self, v, v)
            self[v] = v

    __iter__ = AttributeType.__iter__        

    def values(self):
        return self.__values__

    def epydoc_doc (self):
        try:
            e = AttributeType.epydoc_doc(self)
            if e:
                return e
            return "Possible values: %s" % (', '.join(map(repr, self.values())))
        except Exception, e:
            print "feh %s" % e

#    def epydoc_type(self):
#        try:
#            return self.__epydoc_type__
#        except:
#            return ', '.join(map(repr,self.values()))


_double = AttributeType (float, str, 'float', 'float')
_int = AttributeType (int, lambda x: str(int(x)), 'integer', 'int')
_str = AttributeType (identity, str, 'string', 'str')
clusterMode = enum(_str, ['local','global','none'], 'string')
color = _str # FIXME -- implement correctly
colorList = _str # FIXME -- implement correctly

rect = AttributeType (
    lambda s: [int, s.split(',')], 
    lambda x: ','.join([str(int(x)) for y in x]) ,
    'string',
    'rect',
    'description of rect type',
    )

point = AttributeType (
    lambda s: tuple(map(int,s.split(','))),
    lambda p: ','.join([str(int(x)) for x in p]),
    'point2d',
    '(x,y) or (x,y,z) tuple',
)


rankType = enum(_str, ['same', 'min', 'source', 'max', 'sink'], 'string')

def _py_to_bool(x):
    if x:
        return 'true'
    else:
        return 'false'

bool = AttributeType (
    {'false':False,'true':True}.get, 
    _py_to_bool,
    'integer',
    'boolean',
)

arrowtype = enum(
    _str, 
    ['normal','inv','dot','invdot','odot',
    'invodot','none','tee','empty','invempty',
    'diamond','odiamond','ediamond','crow',
    'box','obox','open','halfopen','vee'],
    'string',
    )

dirType = enum(_str, ['forward', 'both', 'back', 'none'], 'string', 'string', 'dirtype description')

portPos = enum(_str, ['n', 'ne', 'e', 'se', 's', 'sw', 'w', 'nw', 'center'], 'string') # FIXME implement correctly

outputMode = enum(_str, ['breadthfirst', 'nodesfirst', 'edgesfirst'], 'string')

pagedir = enum(_str, ['BL','BR','TL','TR','RB','RT','LB','LT'], 'string')
rankdir = enum(_str, ['TB','LR','BT','RL'], 'string')

viewPort =  _str # FIXME!

shapes = enum(_str,
    ['box', 'polygon', 'ellipse', 'circle','point', 'egg', 'triangle', 'plaintext', 'diamond', 'trapezium',
    'parallelogram', 'house','pentagon','hexagon','septagon','octagon','doublecircle','doubleoctagon',
    'tripleoctagon','invtriangle','invtrapezium', 'invhouse','Mdiamond', 'Msquare',
    'Mcircle', 'rect', 'rectangle','none',
    'record', 'Mrecord'],
    'string',
    )

layerRange = _str
layerList = _str # FIXME implement correctly

packMode = enum(_str, ['node','clust','graph'], 'string')

def groupiter(it, groupsize):
    itz = iter(it)
    while True: 
        yield [itz.next() for j in xrange(groupsize)]

class EdgePosition(list):
    """ Just like a normal list, except with "end" and "start" attributes which may be set to end and start points of the splin.
        end and start may also be None"""
    end = None
    start = None
    def __init__(self, *args, **keywords):
        list.__init__(self, *args, **keywords)
        
class splineType(AttributeType):
    # currently handles only splines of form:
    #   e,x1,y1 x2,y2 x3,y3 ... xN,yN
    def __init__(self):
        AttributeType.__init__(self, self.to_python, self.from_python, 'object')

    def to_python(self, s):
        words = s.split(' ')
        if words[0].startswith('e'):
            a,b = words[0].split(',')[1:]
            endpoint = (int(a),int(b)) 
            words.pop(0)
        else:
            endpoint = None
        if words[0].startswith('s'):
            a,b = words[0].split(',')[1:]
            startpoint = (int(a),int(b)) 
            words.pop(0)
        else:
            startpoint = None
        points = EdgePosition([ map(int,x.split(',')) for x in words ])
        points.start = startpoint
        points.end = endpoint
        return points

    def from_python(self, pointslist):
        return 'e,' + ' '.join(['%s,%s'%(x,y) for x,y in pointslist])

splineType = splineType()

pointf = AttributeType ( # FIXME - implement correctly (constraint to dim values)
    lambda s: [float, s.split(',')], 
    lambda x: ','.join([str(float(y)) for y in x]) ,
    'point2d',
    'pointf',
)

pointfList = _str # FIXME!

startType = enum(_str, ['regular','self','random'], 'string') # FIXME

style = _str # FIXME

