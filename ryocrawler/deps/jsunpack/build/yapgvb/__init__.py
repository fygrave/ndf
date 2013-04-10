# 
# This file is a part of the Yapgvb software package, and is 
# licensed under the New BSD License.
# A `LICENSE' file should have been included with this source.
#
# Copyright (c) 2009 Lonnie Princehouse
#

"""
Yet Another Python Graphviz Binding, Version %(__version__)s

This is only an API reference.  There is currently no tutorial, but the scripts in the examples directory should be helpful for a quick introduction.

Documentation credits go to the authors of the Graphviz documentation, whence the graph/node/edge property descriptions were brazenly copied.
"""

import graph_attributes, graph_attribute_types, mneumonics
from mneumonics import *

try:
    from _yapgvb import *
    using_boost = True
except ImportError:
    # Try the command-line backend instead
    from _yapgvb_py import *
    using_boost = False

import types, sys, os
from graph_attributes import _init_graph_attributes, _implement_graph_attributes, GraphAttributeProperty
from graph_attribute_types import *

__version__ = '1.2.3'
__doc__ = __doc__ % locals()

class SubgraphBase(object):
    pass

class ClusterBase(object):
    pass

_implement_graph_attributes(_init_graph_attributes(CGraph, ClusterBase, Node, Edge, SubgraphBase))

# Make the wrapped C++ classes a little more Pythonic...
def _forward_iterator (first, next):
    def _it (obj):
        try:
            x = first(obj)
        except IndexError:
            raise StopIteration
        yield x
        while True:
            x = next(obj, x)
            yield x
    return _it


def _embellish_c_classes():

    def readonly(original):
        def f(obj, attr, value):
            if hasattr(obj, attr) or hasattr(obj.__class__, attr) or attr.startswith('_'):
                return original(obj,attr,value)
            else:
                raise Exception("Cannot create new attributes for C wrapper classes.")
        return f

    try:     
        Node.__doc__ = """
Nodes are created by calling Graph.add_node.  

Edges can be created through the use of overloaded operators -, <<, and >>.

@group Graph Definition: __sub__, __lshift__, __rshift__
@group Graph Traversal: edges, inbound_edges, outbound_edges, graph
"""
    except:
        pass

    if using_boost:
        Node.edges = property(_forward_iterator (Node.first_edge, Node.next_edge))

        Node.outbound_edges = property(_forward_iterator (Node.first_outbound_edge, 
            Node.next_outbound_edge))
        Node.inbound_edges = property(_forward_iterator (Node.first_inbound_edge, 
            Node.next_inbound_edge))
        
    
    Node.__str__ = lambda n: n.name
    Node.__repr__ = lambda n: '<%s "%s">' % (n.__class__.__name__, n)
    
    # making nodes comparable makes it easy to convert this into a boost.graph structure
    def __cmp__(node_a,node_b):
        """Nodes are made comparable because it makes the boost.graph conversion easier.  The comparison doesn't mean anything, but will always return the same sort order for a set of nodes. """
        return cmp(node_a.name, node_b.name)
   
    Node.__setattr__ = readonly(Node.__setattr__)
    Node.__cmp__ = __cmp__

    if using_boost:
        Node.graph = property(lambda n: n.__get_graph__().__unique__(), doc="The graph to which a Node belongs.")
    
    def __lshift__(head, tail):
        """The syntax head_node << tail_node creates a directed edge between two nodes.  It is a convenient short syntax for head_node.graph.add_edge(tail_node, head_node). An Edge object is returned.  For undirected graphs, a << b is equivalent to a - b.

@attention: Both nodes must belong to the same graph.  This is not currently enforced, so be careful.
        """
        return head.graph.add_edge(tail, head)

    Node.__lshift__ = __lshift__

    def __rshift__(tail, head):
        """The syntax tail_node >> head_node creates a directed edge between two nodes.  It is a convenient short syntax for tail_node.graph.add_edge(tail_node, head_node). An Edge object is returned.  For undirected graphs, a >> b is equivalent to b - a.

@attention: Both nodes must belong to the same graph.  This is not currently enforced, so be careful.
        """
        return tail.graph.add_edge(tail, head)
    Node.__rshift__ = __rshift__
    
    def __sub__(tail, head):
        """The syntax tail_node - head_node creates an undirected edge between two nodes.  It is a convenient short syntax for tail_node.graph.add_edge(tail_node, head_node). An Edge object is returned.  This should only be used for undirected graphs; use << and >> to create directed edges.

@attention: Both nodes must belong to the same graph.  This is not currently enforced, so be careful.
        """
        return tail.graph.add_edge(tail, head)
    Node.__sub__ = __sub__

    Node.__eq__ = lambda a,b: hash(a) == hash(b)

    Edge.__setattr__ = readonly(Edge.__setattr__)
    CGraph.__setattr__ = readonly(CGraph.__setattr__)
    
    try:
        Edge.__doc__ = """
Edges are created either through the GraphBase.add_node, or by using the overloaded Node operators <<, >> , and - operators (for directed, directed, and undirected graphs respectively).
"""
    except:
        pass

    if using_boost:
        Edge.head = property(lambda e: e.__get_head__(), doc="The edge's head (source) node")
        Edge.tail = property(lambda e: e.__get_tail__(), doc="The edge's tail (destination) node")
        Edge.graph = property(lambda e: e.head.graph)
    
    def __iter__(self):
        "Iterates over (tail, head)"
        return iter( (self.tail, self.head) )

    Edge.__iter__ = __iter__
    Edge.__eq__ = lambda a,b: hash(a) == hash(b)
    
    def _edgerep(e):
        if e.graph.directed:
            egop = '->'
        else:
            egop = '-'
        return '<%s %s %s %s>' % (e.__class__.__name__, e.tail, egop, e.head)
         
    Edge.__repr__ = _edgerep

    def _declare_attribute(self, element, name, default):
        if isinstance(element, CGraph):
            return self.declare_graph_attribute(name, default)
        elif isinstance(element, Node):
            return self.declare_node_attribute(name, default)
        elif isinstance(element, Edge):
            return self.declare_edge_attribute(name, default)
        else:
            raise Exception("element argument must be either a CGraph, Node, or Edge")

    CGraph.declare_attribute = _declare_attribute
    CGraph.__registry__ = {}

    CGraph.__unique__ = lambda self: self.__class__.__getcached__(self)

    def _cgraph_getcached(cls, graph):
        h = hash(graph)
        if h in cls.__registry__:
            return cls.__registry__[h]
        else:
            cls.__registry__[h] = graph
            return graph

    CGraph.__getcached__ = classmethod(_cgraph_getcached)
    
    CGraph.__original_init__ = CGraph.__init__
    def cgraph_init_wrapper(self, *a, **b):
        CGraph.__original_init__(self, *a,**b) 
        if self.directed and not isinstance(self, Digraph):
            self.__class__ = Digraph
        elif not self.directed and not isinstance(self, Graph):
            self.__class__ = Graph
    

    CGraph.__init__ = cgraph_init_wrapper
    
    def iteredges(g):
        known = {}
        # yuck.. is there a better way to do this?!
        for node in g.nodes:
            for edge in node.edges:
                if edge in known:
                    continue
                else:
                    known[edge] = True
                    yield edge

    if using_boost:
        CGraph.edges = property(iteredges, doc="An iterator of edges contained in the graph.")


_embellish_c_classes()

class GraphBase(CGraph):
    """
GraphBase is the base class for Graph and Digraph.  GraphBase should not be instantiated directly.

@group Graph Definition: add_node, add_edge
@group Graph Traversal: nodes, edges
@group Layout and Rendering: layout, render
@group I/O: write, render, read
@group Boost.Graph Compatibility: from_bgl, to_bgl
    """
    __subgraph_class__ = None

    @classmethod
    def _create_subgraph_class(cls):
        #return type("Sub"+cls.__name__.lower(), (cls, SubgraphBase), {})
        return cls # FIXME!!!  The above commented line is more correct, but SubgraphBase and ClusterBase need to be implemented to work with attributes!!!

    def add_edge(self, tail, head):
        "Create an edge between two nodes.  Returns the created edge object." 
        return CGraph.add_edge(self, tail, head) 
    
    def write(self, output_stream_or_filename=sys.stdout):
        "Output the graph in the dot language format.  To render as an image, use the render() method.  To read a dot file, use the __init__ constructor or the read() classmethod."
        if isinstance(output_stream_or_filename, str):
            output_stream_or_filename = open(output_stream_or_filename,'w')
            closeme = True
        else:
            closeme = False
        CGraph.write(self, output_stream_or_filename)
        if closeme:
            output_stream_or_filename.close()
    
    @classmethod
    def read(cls, input_stream_or_filename):    
        "Read a graph from a dot file.  May be called from either the Digraph or Graph class; either way, the correct directed or undirected graph object will be returned."
        if isinstance(input_stream_or_filename, str):
            input_stream_or_filename = open(input_stream_or_filename,'r')
            closeme = True
        else:
            closeme = False
        newgraph = cls(input_stream_or_filename)
        if closeme:
            input_stream_or_filename.close()
        return newgraph

    def get_subgraph_class(self):
        if self.__subgraph_class__:
            return self.__subgraph_class__
        else:
            self.__subgraph_class__ = self._create_subgraph_class()
            return self.__subgraph_class__                

    def subgraph(self, name):
        sg = CGraph.subgraph(self, name) 
        cached = sg.__unique__()
        if cached is sg:
            cached.__class__ = self.get_subgraph_class()
        return cached

    def get(cls, *a, **b):
        newobj = super(CGraph,cls).__new__(*a, **b)
        cached = CGraph.registry.get(newobj,None)
        if cached:
            del newobj
            return cached
        else:
            return 
    
    def __init__(self, *args, **keywords):
        """GraphBase is a base class used by Graph and Digraph.  Do not instantiate it directly. """
        CGraph.__init__(self,*args,**keywords)
        CGraph.__registry__[self] = self

    __default_rendering_context__ = None
    
    def default_rendering_context(self):
        if self.__default_rendering_context__ is None:
            self.__default_rendering_context__ = RenderingContext()
        return self.__default_rendering_context__

    def layout(self, engine, rendering_context = None):

        if not rendering_context:
            rendering_context = self.default_rendering_context()
        return rendering_context.layout(self, engine)
    layout.__doc__ = """
Process the graph with one of the layout engines supplied by Graphviz.  

@param engine: Name of the layout engine.  Possible values are %s.
@param rendering_context: Leave this as None for now.  It will be explained when I have time to write more documentation ;-)
""" % ', '.join(map(repr,engines.values()))
   
    def render(self, outstream=sys.stdout, format=None, rendering_context=None):

        close_stream = False

        if isinstance(outstream, (str, types.UnicodeType)):
            # try to open as a file
            filename = str(outstream)
            if sys.platform != 'win32':
                outstream = open(filename, 'wb')
                close_stream = True
            else:
                # Warning!  Hackish work-around!
                #   The file handle will be opened in C, because
                #   something about building this on Windows
                #   causes Python file handles to break when they're
                #   passed to render through Boost's extraction 
                #   mechanism.
                #
                # This means that, on Windows, it isn't possible to render
                # to arbitrary Python stream objects.
                outstream = str(outstream)
            if format is None:
                # attempt to infer format from filename
                extension = os.path.splitext(filename.lower())[-1]
                if extension:
                    extension = extension[1:]
                    if extension in formats.values():
                        format = extension
        elif sys.platform == 'win32':
            raise NotImplementedException("yapgvb on Windows can't render to arbitrary file objects.  Please pass the outstream argument as a filename.  (this bug is explained in the source code)")

        if format is None:
            raise Exception("Can't infer a rendering format from outstream argument.  Please specify a format explicitly.")

        if not rendering_context:
            rendering_context = self.default_rendering_context()
        result = rendering_context.render(self, format, outstream)
        if close_stream:
            outstream.close()
        return result
    
    if using_boost:

        nodes = property(_forward_iterator(CGraph.first_node, CGraph.next_node), doc="An iterator over all nodes in the graph")

    render.__doc__ = """
Render the graph to a file.  layout must be called prior to rendering.

@param outstream: Either a filename or an open, writable file stream.
@param format: Desired file format.  One of %s.
@param rendering_context: Leave this as None for now.  It will be explained when I have time to write more documentation ;-)
@note: If format is None (the default) and outstream is a filename, render will attempt to infer the correct format from the filename extension.
@attention: If you're writing a binary format, be sure to open outstream as a binary stream.
""" % ', '.join(map(repr,formats.values()))

    def __str__(self):
        return self.name
    
    def __repr__(self):
        return '<%s "%s">' % (self.__class__.__name__, self)
    
    def __unique_node_name__(self):
        # okay, so it's not guaranteed unique... but pretty close
        import random
        return ''.join([random.choice('abcdefghijklmnopqrstuvwxyz') for i in xrange(32)])

    def add_node(self, name=None, **attributes): 
        """Add a node to the graph.  If a node of this name exists already, it will be returned and no new node will be created.  If no name is specified, a random (and probably unique) name will be assigned.
The keyword arguments are (attribute_name, value) pairs; this is a shorthand equivalent to assigning attributes individually:

n = mygraph.add_node('node_name', label="Hello World", fontsize=48)

is equivalent to:

n = mygraph.add_node('node_name')
n.label = 'Hello World'
n.fontsize = 48
"""
        if name is None:
            name = self.__unique_node_name__()
        node = CGraph.add_node(self, name)
        for key, value in attributes.iteritems():
            setattr(node, key, value)
        return node

    graph = property(lambda g: g, doc = 'graph to which this belongs (parent, if a subgraph, otherwise self)')

    def to_bgl(ygraph, node_properties=[], edge_properties=[]):
        """
Translate a graphviz graph into a boost.python graph.

The returned translation_map behaves like a dictionary of all corresponding (boost_edge, yapgvb_edge), (yapgvb_edge, boost_edge), (boost_vertex, yapgvb_node), and (yapgvb_node, boost_vertex) key/value pairs.

@param bgraph: A yapgrvb.Graph or yapgvb.Digraph instance
@param node_properties: A list of strings naming node properties to converted from yapgvb to boost.
@param edge_properties: A list of strings naming edge properties to converted from yapgvb to boost.
@return: (bgraph, translation_map)
        """
        import boost.graph as bgl
        if ygraph.directed:
            graph = bgl.Digraph()
        else:
            graph = bgl.Graph()
        
        map = BoostTranslationMap(ygraph, graph)
    
        for node in ygraph.nodes:
            v = graph.add_vertex()
            map[node] = v
            map[v] = node
             
        for edge in ygraph.edges:
            e = graph.add_edge(map[edge.tail], map[edge.head])
            map[edge] = e
            map[e] = edge
        
        for property_name in node_properties:
            if isinstance(property_name, GraphAttributeProperty):
                prop = property_name
                property_name = prop.name
            else:
                try:
                    prop = getattr(Node,property_name)
                except:
                    raise AttributeError("Node class has no property '%s'" % property_name)
            prop_map = graph.vertex_property_map(prop.bgl_type)
            graph.vertex_properties[property_name] = prop_map
    
            for y in ygraph.nodes:
                b = map[y]
                prop_map[b] = prop.fget(y)
            
        for property_name in edge_properties:
            if isinstance(property_name, GraphAttributeProperty):
                prop = property_name
                property_name = prop.name
            else:
                try:
                    prop = getattr(Edge,property_name)
                except:
                    raise AttributeError("Edge class has no property '%s'" % property_name)
            prop_map = graph.edge_property_map(prop.bgl_type)
            graph.edge_properties[property_name] = prop_map
    
            for y in ygraph.edges:
                b = map[y] 
                prop_map[b] = prop.fget(y)
        
        return graph, map
    
    @classmethod
    def from_bgl(cls, bgraph, node_properties = [], edge_properties = []):
        """
Translate a boost.python graph into a yapgvb graph.

The returned translation_map behaves like a dictionary of all corresponding (boost_edge, yapgvb_edge), (yapgvb_edge, boost_edge), (boost_vertex, yapgvb_node), and (yapgvb_node, boost_vertex) key/value pairs.

@param bgraph: A boost.graph.Graph or boost.graph.Digraph instance
@param node_properties: A list of strings naming node properties to converted from boost to yapgvb.
@param edge_properties: A list of strings naming edge properties to converted from boost to yapgvb.
@return: (ygraph, translation_map)
"""
    
        import boost.graph

        # yapgvb 1.1.2 => changed from 'Directed' to 'Digraph'
        # (bug and fix pointed out by Johannes Brunen)
        if bgraph.__class__.__name__ == 'Digraph':
            ygraph = Digraph()
        elif bgraph.__class__.__name__ == 'Graph':
            ygraph = Graph()
        else:
            raise Exception("unrecognized boost graph class %s" % bgraph)
        
        edgemaps = [(name, bgraph.edge_properties[name]) for name in edge_properties]

        # yapgvb 1.1.2 => changed from bgraph.node_properties to 
        # bgraph.vertex_properties
        # (bug and fix pointed out by Johannes Brunen)
        nodemaps = [(name, bgraph.vertex_properties[name]) for name in node_properties]

        map = BoostTranslationMap(ygraph, bgraph)
    
        for i, vertex in enumerate(bgraph.vertices):
            n = ygraph.add_node(str(i))
            map[vertex] = n
            map[n] = vertex

            # yapgvb 1.1.2 bug and fix pointed out by Johannes Brunen
            for propname, prop_map in nodemaps:
                boost_property_value = prop_map[vertex]
                setattr(n, propname, boost_property_value) 
        
        for edge in bgraph.edges:
            source = map[bgraph.source(edge)]
            target = map[bgraph.target(edge)]
            e = ygraph.add_edge(source, target)
            map[edge] = e
            map[e] = edge

            # yapgvb 1.1.2 bug and fix pointed out by Johannes Brunen
            for propname, prop_map in edgemaps:
                boost_property_value = prop_map[edge]
                setattr(e, propname, boost_property_value) 
         
        return ygraph, map
    
    
class Digraph(GraphBase): 
    """
Directed graph class.
"""
    def __init__(self, name_or_open_file = 'untitled digraph', strict=False):
        """Create a new graph, or read an existing graph from a dot file. If name_or_open_file is a string, it will be interpreted as a name for a new graph.  If it is an open filestream, it will be treated as a DOT file and the graph will be read.  If strict is True, only one edge (a,b) will be allowed between nodes a and b; if strict is False, any number of edges (a,b) may exist."""
        arg = name_or_open_file
        if isinstance(arg, file):
            GraphBase.__init__(self, arg)
            return
        elif isinstance(arg, (str, types.UnicodeType)): 
            if strict:
                type = AGDIGRAPHSTRICT
            else:
                type = AGDIGRAPH
            GraphBase.__init__(self, arg, type)
        else:
            # whatever.. let boost deal with it
            GraphBase.__init__(self, arg)

class Graph(GraphBase): 
    """
Undirected graph class.
"""
    def __init__(self, name_or_open_file='untitled graph', strict=False):
        """Create a new graph, or read an existing graph from a dot file. If name_or_open_file is a string, it will be interpreted as a name for a new graph.  If it is an open filestream, it will be treated as a DOT file and the graph will be read.  If strict is True, only one edge (a,b) will be allowed between nodes a and b; if strict is False, any number of edges (a,b) may exist."""
        arg = name_or_open_file
        if isinstance(arg, file):
            GraphBase.__init__(self, arg)
            return
        elif isinstance(arg, (str, types.UnicodeType)): 
            if strict:
                type = AGRAPHSTRICT
            else:
                type = AGRAPH
            GraphBase.__init__(self, arg, type)
        else:
            # whatever.. let boost deal with it
            GraphBase.__init__(self, arg)

class BoostTranslationMap(object):
    def __init__(self, ygraph, bgraph):
        self.ygraph = ygraph
        self.bgraph = bgraph
        self.y_to_b = {}
        self.b_to_y_vertices = bgraph.vertex_property_map('object')
        self.b_to_y_edges = bgraph.edge_property_map('object')
        self._ident = [
            ( lambda x: isinstance(x, (Node, Edge)), self.y_to_b ),
            ( self.is_bgl_vertex, self.b_to_y_vertices ),
            ( self.is_bgl_edge, self.b_to_y_edges ),
        ]

    @staticmethod
    def is_bgl_vertex(x):
        """ isinstance doesn't seem to work for bgl classes.. not sure why """
        c = x.__class__
        return c.__name__ == 'Vertex' and c.__module__ == 'boost.graph._graph'
    
    @staticmethod
    def is_bgl_edge(x):
        """ isinstance doesn't seem to work for bgl classes.. not sure why """
        c = x.__class__
        return c.__name__ == 'Edge' and c.__module__ == 'boost.graph._graph'

    def _identify_map(self, obj):
        for test, map in self._ident:
            if test(obj):
                return map
        raise Exception("%s does not recognize %s" % (repr(self), repr(obj)))

    def __setitem__(self, obj, value):
        self._identify_map(obj)[obj] = value
    
    def __getitem__(self, obj):
        return self._identify_map(obj)[obj]

