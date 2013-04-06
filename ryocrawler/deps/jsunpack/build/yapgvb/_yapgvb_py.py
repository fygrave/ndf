import sys,os

CLI_BACKEND = True

class CLIRenderError(Exception): pass

class PathException(Exception): pass

def check_graphviz_working():
    ier = os.system(find_executable('dot') + ' -?')
    if ier:
        raise PathException("I'm having trouble calling Graphviz executables.  Please make sure Graphviz is in your PATH environment variable.")

def find_executable(engine):
    if sys.platform.startswith('win'):
        return engine + '.exe'
    else:
        return engine

def tempfile(ext,name='yapgvb_temp'):
    import tempfile
    tempdir = tempfile.gettempdir()
    name = name + ext
    i = 0
    n,x = os.path.splitext(name)
    fname = n+str(i)+x
    while os.path.exists(os.path.join(tempdir, fname)):
        i += 1
        fname = n + str(i) + x
    return os.path.join(tempdir, fname)

def readonly(*args):
    raise ReadOnly("That attribute is read-only")

def debug(f):
    def fc(*args, **keywords):
        try:
            return f(*args, **keywords)
        except NotImplementedError,e:
            raise e
        except Exception,e:
            import inspect
            frame = inspect.stack()[1]
            print >> sys.stderr, "*"*80
            print >> sys.stderr, "Function:  %s at %s:%s" % (f.__name__, f.func_code.co_filename, f.func_code.co_firstlineno)
            print >> sys.stderr, "Calling:   %s" % frame[-2][0].strip()
            print >> sys.stderr, "           %s" % repr(frame[1:-2])
            print >> sys.stderr, "%s: %s" % (e.__class__.__name__, e)
            if args:
                print >> sys.stderr, "    Args:"
            else:
                print >> sys.stderr, "    No args."
            for x in args:
                print >> sys.stderr, "        %-30s (%s)" % (repr(x),x.__class__)
            if keywords:
                print >> sys.stderr, "    Keywords:"
                for k,v in sorted(keywords.items()):
                    print >> sys.stderr, "       %s = %-30s (%s)" % (k,repr(v),v.__class__)
            else:
                print >> sys.stderr,"    No keywords."
            raise NotImplementedError("You are using the pure-Python experimental backend.  A lot of things are not implemented yet.")

    return fc

class RenderingContext(object):
    
    @debug
    def layout(self, graph, engine):
        self._layout = engine
        self._engine_executable = find_executable(engine)
    @debug
    def render(self, graph, output_type, destfile):
        if isinstance(destfile,file):
            filename = destfile.name
            destfile.close()
        elif isinstance(destfile,str):
            filename = destfile
        else:
            raise Exception
        temp = tempfile('.dot')
        graph._write_dot(temp)
        cmd = "%s -T%s -o%s %s" % (self._engine_executable, output_type, filename, temp)
        ier = os.system(cmd)
        if ier:
            check_graphviz_working()
            raise CLIRenderError("Error code %s rendering %s" % (ier, temp))

        os.remove(temp)


    @debug
    def free_layout(self, *a, **b):
        try:
            del self._layout
        except:
            pass

        

class CGraph(object):

    # properties:
    #   name, directed, strict
    name = property(lambda x: x._name, readonly)
    directed = property(lambda x: x._is_directed, readonly)
    strict = property(lambda x: x._is_strict, readonly)
    _name = ""

    @debug
    def __init__(self, name_or_sourcefile, graphtype=None):
        if graphtype is None:
            raise NotImplementedError("Reading .dot files is not currently supported in the pure-Python backend.  You'll need to install an older version of Yapgvb that has the Boost backend.  This is temporary.  Sorry.  [If you want to help, please send the author an email!  We need a .dot parser]")
        else:
            name = name_or_sourcefile
        self._name = name
        if graphtype in (AGDIGRAPH, AGDIGRAPHSTRICT):
            self._is_directed = True
        else:
            self._is_directed = False

        if graphtype in (AGRAPHSTRICT, AGDIGRAPHSTRICT):
            self._is_strict = True
        else:
            self._is_strict = False
    
        self._attributes = {}
        self._nodes = []
        self._edges = []
        self._next_hint = 0

    @debug
    def _getnodes(self):
        return iter(self._nodes)
    nodes = property(_getnodes)

    @debug
    def _getedges(self):
        return iter(self._edges)
    edges = property(_getedges)

    @debug
    def add_node(self, *node_args, **node_attrs):
        n = Node(self, *node_args, **node_attrs) 
        self._nodes.append(n)
        return n

    @debug 
    def add_edge(self, n1, n2):
        e = Edge(n1,n2)
        self._edges.append(e)
        return e


    @debug
    def write(self, *a, **b):
        raise NotImplementedError

    @debug
    def declare_graph_attribute(self, *a, **b):
        raise NotImplementedError

    @debug
    def declare_node_attribute(self, *a, **b):
        raise NotImplementedError

    @debug
    def declare_edge_attribute(self, *a, **b):
        raise NotImplementedError

    def __get_attribute__(self,name):
        return self._attributes[name]

    def __set_attribute__(self, name, value):
        self._attributes[name] = value

    def __find_attribute__(self, name):
        return name

    @debug
    def __points_to_same_graph__(self, *a, **b):
        raise NotImplementedError

    @debug
    def first_node(self, *a, **b):
        self._next_hint = 0
        return self._nodes[0]

    @debug
    def last_node(self, *a, **b):
        return self._nodes[-1]

    @debug
    def subgraph(self, *a, **b):
        raise NotImplementedError

    def next_node(self, n):
        if self._nodes[self._next_hint] == n:
            i = self._next_hint
        else:
            for i,n2 in enumerate(self._nodes):
                if n2 == n:
                    break
            else:
                raise StopIteration()
    
        self._next_hint = i + 1
        if self._next_hint >= len(self._nodes):
            raise StopIteration()

        return self._nodes[self._next_hint]

    @debug
    def previous_node(self, *a, **b):
        raise NotImplementedError

    @debug
    def find_edge(self, *a, **b):
        raise NotImplementedError

    @debug
    def find_node(self, *a, **b):
        raise NotImplementedError

    @debug
    def debug_render(self, *a, **b):
        raise NotImplementedError

    @debug
    def debug_file(self, *a, **b):
        raise NotImplementedError

    @debug
    def __attach__(self, *a, **b):
        raise NotImplementedError

    @debug
    def __set_auto_attach__(self, *a, **b):
        raise NotImplementedError

    @debug
    def __get_auto_attach__(self, *a, **b):
        raise NotImplementedError

    @debug
    def is_subgraph(self, *a, **b):
        raise NotImplementedError


    def _write_dot(self, filename):
        f = open(filename,'w')

        def afmt(n,v):
            return "%s=\"%s\"" % (n,v)
        
        def aafmt(atrs):
            return ','.join([afmt(k,v) for k,v in atrs.items()])

        print >> f, self.__class__.__name__.lower(), " \"%s\" {" % self.name

        for k,v in self._attributes.items():
            print >> f, "    " + afmt(k,v)

        if self.directed:
            arrow = "->"
        else:
            arrow = "--"

        for n in self._nodes:
            if n._attributes:
                print >> f, "    %s [%s];" % (n._id, aafmt(n._attributes))
            else:
                print >> f, "    %s;" % n._id

        for e in self._edges:
            if e._attributes:
                print >> f, "    %s %s %s [%s];" % (e._source._id,arrow,e._dest._id,aafmt(e._attributes))
            else:
                print >> f, "    %s %s %s;" % (e._source._id,arrow,e._dest._id)
                
        print >> f, "}"
        f.close()

class Node(object):
    """
Nodes are created by calling Graph.add_node.  

Edges can be created through the use of overloaded operators -, <<, and >>.

@group Graph Definition: __sub__, __lshift__, __rshift__
@group Graph Traversal: edges, inbound_edges, outbound_edges, graph
"""

    _id_counter = 0

    name = property(lambda x: x._name, readonly)
    @debug
    def __init__(self, graph, name):
        self._name = name
        self._graph = graph
        self._attributes = {}
        self._id = Node._id_counter
        Node._id_counter += 1

    graph = property(lambda self: self._graph)

    @debug
    def _getedges(self):
        for e in self._graph._edges:
            if e._source == self or e._dest == self:
                yield e
    edges = property(_getedges)

    @debug
    def _getinedges(self):
        for e in self._graph._edges:
            if e._dest == self:
                yield e
    inbound_edges = property(_getinedges)

    @debug
    def _getoutedges(self):
        for e in self._graph._edges:
            if e._source == self:
                yield e
    outbound_edges = property(_getoutedges)


    def __get_attribute__(self,attrname):
        return self._attributes[attrname]

    def __set_attribute__(self,attrname,value):
        self._attributes[attrname] = value

    def __find_attribute__(self,attrname):
        return attrname

    @debug
    def first_edge(self,*a, **b):
        raise NotImplementedError

    @debug
    def next_edge(self,*a, **b):
        raise NotImplementedError

    @debug
    def first_inbound_edge(self,*a, **b):
        raise NotImplementedError


    @debug
    def next_inbound_edge(self,*a, **b):
        raise NotImplementedError

    @debug
    def first_outbound_edge(self,*a, **b):
        raise NotImplementedError

    @debug
    def next_outbound_edge(self,*a, **b):
        raise NotImplementedError

    @debug
    def __get_graph__(self):
        return self._graph

class Edge(object):
    """ 
Edges are created either through the GraphBase.add_node, or by using the overloaded Node operators <<, >> , and - operators (for directed, directed, and undirected graphs respectively).
"""

    @debug
    def __init__(self, n1, n2):
        self._source = n1
        self._dest = n2
        self._attributes = {}

    head = property(lambda self: self._source)
    tail = property(lambda self: self._dest)
    graph = property(lambda self: self._source._graph)

    def __get_attribute__(self,name):
        return self._attributes[name]

    def __set_attribute__(self,name,value):
        self._attributes[name] = value

    def __find_attribute__(self,name):
        return name

    @debug
    def __get_head__(self,*a, **b):
        raise NotImplementedError

    @debug
    def __get_tail__(self,*a, **b):
        raise NotImplementedError

class AttributeSymbol(object):
    pass

AGRAPH = 0
AGRAPHSTRICT = 1
AGDIGRAPH = 2
AGDIGRAPHSTRICT = 3

del readonly
