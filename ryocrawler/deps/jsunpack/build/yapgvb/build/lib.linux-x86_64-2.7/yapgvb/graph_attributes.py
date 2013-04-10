# 
# This file is a part of the Yapgvb software package, and is 
# licensed under the New BSD license.
# `LICENSE' file should have been included with this source.
#
# Copyright (c) 2009 Lonnie Princehouse
#


# graph attributes are case-sensitive

from graph_attribute_types import *
from graph_attribute_types import _double, _int, _str # explicitly import... * skips _ attributes

def _init_graph_attributes(G,C,N,E,S):
    # FIXME --- handle subgraph, graph correctly
    GC = (G,C)
    ENGC = ENCG = GCNE =(E,N,G,C)
    CNE = (C,N,E)
    ENC = (E,N,C)
    ENG = (E,N,G)
    EGC = (E,G,C)
    NG = (N,G)
    NC = (N,C)
    EN = (E,N)
    GN = (G,N)
    NEC = (N,E,C)
    
    
    # attribute_name : (
    #   tuple of "Used by" classes,
    #   converter functions tuple (string->python, python->string), [default = _str]
    #   default (python value)   [optional]
    #   minimum (python value)   [optional]
    #   maximum (python value)   [optional]
    #   description (string)  --- description is actually the last arg of the tuple, even if no min or max are given
    # )
    _graph_attributes = {
        'Damping' : (G, _double, 0.99, 0.0  ),
        'K' :       (GC, _double, 0.3, 0.0 ), 
        'URL' :     (ENGC,),
        'arrowhead':(E, arrowtype, arrowtype.normal),
        'arrowsize':(E, _double, 1.0, 0.0 ),
        'arrowtail':(E, arrowtype, arrowtype.normal),
        'bb':       (G, rect),
        'bgcolor':  (GC, color),
        'center':   (G, bool, False),
        'charset':  (G, _str, 'UTF-8'),
        'clusterrank': (G, clusterMode, clusterMode.local),
        'color':    (ENC, color, 'black'),
        'colorscheme' : (ENCG, _str, ''),
        'comment' : (ENG, _str, ''),
        'compound' : (G, bool, False),
        'concentrate' : (G, bool, False),
        'constraint' : (E, bool, True),
        'decorate' : (E, bool, False),
        'defaultdist' : (G, _double),
        'dim' : (G, _int, 2, 2),
        'dir' : (E, dirType),
        'distortion' : (N, _double, 0.0, -100.0),
        'dpi' : (G, _double, 96.0, 0.0),
        'epsilon': (G, _double, 0.0001, 0.0),
        'fillcolor': (NC, color),
        'fixedsize': (N, bool),
        'fontcolor': (ENGC, color, 'black'),
        'fontname' : (ENGC, _str, 'Times-Roman'),
        'fontpath' : (G, _str),
        'fontsize' : (ENGC, _double, 14.0, 1.0),
        'group' : (N, _str, ''),
        'headURL' : (E, _str, ''),
        'headclip' : (E, bool, True),
        'headhref' : (E, _str, ''),
        'headlabel' : (E, _str, ''),
        'headport' : (E, portPos, portPos.center),
        'headtarget' : (E, _str),
        'headtooltip' : (E, _str),
        'height' : (N, _double, 0.5, 0.02),
        'href' : (E, _str, ''),
        'label' : [
            (EGC, _str, ''),
            (N, _str), # FIXME runtime default dependency
        ],
        'labelangle' : (E, _double, -25., -180.),
        'labeldistance' : (E, _double, 1.0, 0.0),
        'labelfloat' : (E, bool, False),
        'labelfontcolor' : (E, color, 'black'),
        'labelfontname': (E, _str, 'Times-Roman'),
        'labelfontsize' : (E, _double, 14., 1.0),
        'labeljust' : (GC, _str, 'c'),
        'labelloc' : (GC, _str), # FIXME runtime default dependency
        'landscape' : (G, bool, False),
        'layer': (EN, layerRange, ''),
        'layers' : (G, layerList),
        'layersep' : (G, _str, ':\\t'),
        'len' : (E, _double), # FIXME runtime default dependency
        'levelsgap' : (G, _double, 0.0),
        'lhead' : (E, _str, ''),
        'lp': (EGC, point),
        'ltail' : (E, _str, ''),
        'margin' : (NG, _double), # FIXME runtime default dependency, munged type
        'maxiter' : (G, _int), # FIXME runtime default dependency
        'mclimit' : (G, _double, 1.0),
        'mindist' : (G, _double, 1.0, 0.0),
        'minlen' : (E, _int, 1, 0),
        'mode' : (G, _str, 'major'),
        'model' : (G, _str, 'shortpath'),
        'nodesep' : (G, _double, 0.25, 0.02),
        'nojustify':  (GCNE, bool, False),
        'normalize' : (G, bool, False),
        'nslimit' : (G, _double),
        'nslimit1' : (G, _double),
        'ordering' : (G, _str, ''),
        'orientation' :  [
            (N, _double, 0.0, 360.),
            (G, _str, ''),
        ],
        'outputorder' : (G, outputMode, outputMode.breadthfirst),    
        'overlap': (G, _str,''),
        'pack': (G, bool, False),
        'packmode' : (G, packMode, packMode.node),
        'page' : (G, pointf),
        'pagedir' : (G, pagedir, pagedir.BL),
        'pencolor' : (C, color, 'black'),
        'penwidth' : (CNE, _double),
        'peripheries' : [
            (N, _int, 0),
            (C, _int, 0),
        ],
        'pin' : (N, bool, False),
        'pos': [
            (N, point),
            (E, splineType),
        ],
        'quantum' : (G, _double, 0., 0.),
        'rank' : (G, rankType),  # FIXME!!! This should be (C, rankType) ... but ClusterBase is not implemented correctly
        'rankdir' : (G, rankdir, rankdir.TB),
        'ranksep': (G, _double),
        'ratio': (G, _double),
        'rects' : (N, rect),
        'regular' : (N, bool, False),
        'remincross' : (G, bool, False),
        'resolution' : (G, _double, 96.0, 0.0),
        'root' : [
            (G, _str, ''),
            (N, bool, False),
        ],
        'rotate' : (G, _int, 0),
        'samehead': (E, _str, ''),
        'sametail' : (E, _str, ''),
        'samplepoints' : (G, _int, 8),
        'searchsize' : (G, _int, 30),
        'sep' : (G, _double, 0.1),
        'shape' : (N, shapes, shapes.ellipse),
        'shapefile': (N, _str, ''),
        'showboxes' : (ENG, _int, 0, 0),
        'sides' : (N, _int, 4, 0),
        'size' : (G, pointf),
        'skew' : (N, _double, 0., -100.),
        'splines' : (G, _str), # FIXME
        'start' : (G, startType, startType.random),
        'style' : (ENC, style),    
        'stylesheet' : (G, _str, ''),
        'tailURL' : (E, _str, ''),
        'tailclip': (E, bool, True),
        'tailhref' : (E, _str, ''),
        'taillabel' : (E, _str, ''),
        'tailport' : (E , portPos, portPos.center),
        'tailtarget' : (E, _str),
        'tailtooltip' : (E, _str),
        'target' : (ENGC, _str),
        'tooltip' : (NEC, _str),
        'truecolor' : (G, bool),
        'vertices' : (N, pointfList),
        'viewport' : (G, viewPort, ''),
        'voro_margin' : (G, _double, 0.05, 0.),
        'weight' : (E, _double, 1.),
        'width' : (N, _double, 0.75, 0.01),
        'z': (N, _double, 0.),
    }
    return _graph_attributes

def _implement_graph_attributes(_graph_attributes):
    for attribute_name, definition in _graph_attributes.iteritems():
        if isinstance(definition, list): 
            for d in definition:
                if isinstance(d[-1], str) and len(d) != 3:
                    kw = {'description': d[-1]}
                    d = d[:-1]
                else:
                    kw = {}
                _implement_graph_definition(attribute_name, *d) 
        else:
            d = definition
            if isinstance(d[-1], str) and len(d) != 3:
                kw = {'description': d[-1]}
                d = d[:-1]
            else:
                kw = {}
            _implement_graph_definition(attribute_name, *d, **kw) 

class GraphAttributeProperty(property):
    def __init__(self, name, translator=_str, default=None, minimum=None, description=None):
        self.name = name
        self.to_python, self.from_python = translator
        self.bgl_type = translator.bgl_type
        self.default = default
        self.minimum = minimum
        property.__init__(self, self._fget, self._fset, doc=description)
    
    def declare(self, i):
        return i.graph.declare_attribute(i, self.name, self.get_default())

    def get_default(self):
        if self.default is None:
            return ''
        else:
            return self.from_python(self.default)

    def get_symbol(self, i, create=True):
        try:
            return i.__find_attribute__(self.name)
        except KeyError:
            if create:
                return self.declare(i)
            else:
                return None
    
    def _fget(self, i):
        symbol = self.get_symbol(i, False)
        if symbol:
            return self.to_python(i.__get_attribute__(symbol))
        else:
            return self.default
    
    def _fset(self, i, value):
        value = self.from_python(value)
        i.__set_attribute__(self.get_symbol(i), value)

class NodePinProperty(GraphAttributeProperty):

    def _fget(self, i):
        symbol = self.get_symbol(i, False)
        if symbol:
            raw = i.__get_attribute__(symbol)
            return self.to_python(raw)
        else:
            try:
                pos_symbol = i.__find_attribute__('pos')
            except KeyError:
                return self.default
            raw_position = i.__get_attribute__(pos_symbol)
            return raw_position.endswith('!')
                    
class NodePositionProperty(GraphAttributeProperty):
    def _fget(self, i):
        symbol = self.get_symbol(i, False)
        if symbol:
            raw = i.__get_attribute__(symbol)
            if raw.endswith('!'):
                raw = raw[:-1]  # pinned
            return self.to_python(raw)
        else:
            return self.default
    
def _implement_graph_definition(attribute_name, classes, translator=_str, default=None, minimum=None, description=None):
    if isinstance(classes, tuple):
        for cls in classes:
            setattr(cls, attribute_name, GraphAttributeProperty(attribute_name, translator, default, minimum, description))
    else:
        if attribute_name == 'pos':
            property_class = NodePositionProperty
        elif attribute_name == 'pin':
            property_class = NodePinProperty
        else:
            property_class = GraphAttributeProperty
        setattr(classes, attribute_name, property_class(attribute_name, translator, default, minimum, description))
         

