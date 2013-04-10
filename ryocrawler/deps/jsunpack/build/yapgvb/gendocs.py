#!/usr/bin/env python

# 
# This file is a part of the Yapgvb software package, and is 
# licensed under the New BSD license.
# A `LICENSE' file should have been included with this source.
#
# Copyright (c) 2009 Lonnie Princehouse
#

import inspect, os, sys, re

import yapgvb as y
from yapgvb import graph_attributes as ygraph_attributes
from yapgvb import graph_attribute_types as ygraph_attribute_types

def srepr(s):
    return '"""%s"""' % s 

_repr = repr

def repr(x):
    if x is sys.stdout:
        return 'sys.stdout'
    elif x is sys.stderr:
        return 'sys.stderr'
    else:
        return _repr(x)
    
class DocProperty(object):
    def __init__(self, name, doc):
        self.name = name
        self.doc = doc
    
    def __str__(self):
        if self.doc:
            return "%s = property(doc=%s)" % (self.name, srepr(self.doc))
        else:
            return "%s = property()" % (self.name)

    @classmethod
    def evoke(cls, name, p, doc=None):
        # p is a real property
        if doc is None:
            doc = p.__doc__
        return cls(name, doc)

class DocFunction(object):
    # argspec is (args, varargs, varkw, defaults)
    def __init__(self, name, doc, argspec, classmethod=False):
        self.name = name
        self.doc = doc
        self.argspec = argspec
        self.classmethod = classmethod 

    @classmethod
    def evoke(cls, f):
        try:
            f, classmethod = f
        except:
            classmethod = False

        try:
            return cls(f.__name__, f.__doc__, inspect.getargspec(f), classmethod)
        except: 
            try:
                return cls(f.__name__, f.__doc__, f.__argspec__, classmethod)
            except:
                return cls(f.__name__, f.__doc__, ([],'arguments','keywords',None), classmethod)

    def __str__(self):
        myname = self.name
        if self.doc:
            docstr = srepr(self.doc)
        else:
            docstr = ''
        
        args, varargs, varkw, defaults = self.argspec
        
        a = []
        if args:
            a += list(args)
        if defaults:            
            offset = len(args) - len(defaults)
            for i, d in enumerate(defaults):
                args[offset + i] += ' = %s' % repr(d)
        if varargs:
            args += ['*'+varargs]
        if varkw:
            args += ['**'+varkw]
         
        arg = ', '.join(args)
        if self.classmethod:
            cm = '@classmethod\n'
        else:
            cm = ''
        return """%(cm)sdef %(myname)s (%(arg)s):
    %(docstr)s
    pass
""" % locals()

        
def indent(i, s):
    return i + ('\n'+i).join(s.split('\n'))

class DocClass(object):
    def __init__(self, name, bases, doc=None):
        self.properties = []
        self.methods = []
        self.name = name
        self.doc = doc
        self.bases = bases
    
    def add_properties(self, plist):
        self.properties += plist
        return self

    def add_methods(self, plist):
        self.methods += plist
        return self

    def __str__(self):
        if not self.bases:
            #baselist = 'object'
            baselist = ''
        else:
            baselist = ', '.join([b.name for b in self.bases])
            baselist =  '(%s)' % baselist
        myname = self.name
        if self.doc:
            docstr = srepr(self.doc)
        else:
            docstr = ''
        
        properties = '\n    '.join([str(p) for p in self.properties])
        methods = indent('    ','\n'.join([str(m) for m in self.methods]))
        
        return """
class %(myname)s%(baselist)s:
    %(docstr)s
    %(properties)s
%(methods)s
    pass

""" % locals()

class DocModule(object):
    def __init__(self, name, package, doc):
        self.name = name
        self.package = package
        self.doc = doc
        self.entities = ['import sys']
        self.file = os.path.join(package.directory, name + '.py')
    
    def public_list(self):
        return [e.name for e in self.entities if hasattr(e, 'name') and not (hasattr(e, 'private') and e.private)]

    def write(self):
        if os.path.exists(self.file):
            raise Exception("%s already exists... I do not overwrite things!" % self.file)
        else:
            f = open(self.file, 'w')
        
        if self.doc:
            print >> f, srepr(self.doc)

        for e in self.entities:
            print >> f, str(e)
        
        f.close()

class DocPackage(object):
    def __init__(self, name, base_dir, doc):
        self.directory = os.path.join(base_dir,name)
        
        self.init = DocModule('__init__', self, doc)
        self.modules = [self.init]

    def write(self):
        mlist = ', '.join([repr(n.name) for n in self.modules if n is not self.init])

        self.init.entities += ['__all__ = [%s] + %s' % (mlist, repr(self.init.public_list()))]

        if os.path.exists(self.directory):
            raise Exception("%s already exists... I do not overwrite things!" % self.directory)
        else:
            os.mkdir(self.directory)
        
        for m in self.modules:
            m.write()

def implement_pseudograph_attributes(G,C,N,E,S):
    _graph_attributes = ygraph_attributes._init_graph_attributes(G,C,N,E,S)

    for attribute_name, definition in _graph_attributes.iteritems():
        if not isinstance(definition, list):
            definition = [definition]

        for d in definition:
            if isinstance(d[-1], str) and len(d) != 3:
                kw = {'description': d[-1]}
                d = d[:-1]
            else:
                kw = {}

            implement_graph_pseudodefinition(attribute_name, *d, **kw) 
       
def redent(x):
    return '\n'.join(map(str.strip, x.split('\n')))

def strip_html(x):
    r = re.compile('<.*?>')
    return r.sub('',x)

def download_attr_descriptions():
    dict = {}
    r = re.compile("<DT><A NAME=d:(?P<name>[a-zA-Z]*) HREF=#a:[a-zA-Z]*><STRONG>[a-zA-Z]*</STRONG></A>\n<DD>(?P<body>.*?)(?=<DT>)",re.DOTALL)
    import urllib
    try:
        u = 'http://www.graphviz.org/doc/info/attrs.html'
        f = urllib.urlopen(u)
    except:
        f = open('attrs.html','r')
    d = f.read()
    f.close()
    for aname, desc in r.findall(d):
        desc = strip_html(desc)
        dict[aname] = redent(desc)
    return dict

attribute_descriptions = download_attr_descriptions()

def implement_graph_pseudodefinition(attribute_name, classes, translator=None, default=None, minimum=None, description=None):
    doc = description
    
    if not doc:
        doc = ''
    
    doc += '\n' + attribute_descriptions.get(attribute_name,'')

    try:
        epydoc_doc = translator.epydoc_doc()
        if epydoc_doc:
            if not doc:
                doc = ''
            doc = doc +"\n\n%s\n" % epydoc_doc
    except:
        pass

    try:
        epydoc_type = translator.epydoc_type()
        if not doc:
            doc = ''
        doc = doc +"\n\n@type: %s\n" % epydoc_type
    except:
        pass

    if isinstance(classes, tuple):
        for cls in classes:
            p = DocProperty(attribute_name, doc)#translator, default, minimum)
            cls.properties += [p]
    else:
        p = DocProperty(attribute_name, doc)#translator, default, minimum)
        classes.properties += [p]
    
def create_yapgvb_pseudomod(basedir='pseudomod'):
    
    if not os.path.exists(basedir):
        os.mkdir(basedir)

    package = DocPackage('yapgvb', basedir, y.__doc__)

    GraphBase = DocClass('GraphBase', None, y.GraphBase.__doc__).add_methods(map(DocFunction.evoke, [
        y.GraphBase.add_node,
        y.GraphBase.add_edge,
        y.GraphBase.write,
        y.GraphBase.layout,
        y.GraphBase.render,
        y.GraphBase.__init__,
        y.GraphBase.to_bgl,
        (y.GraphBase.from_bgl,True),
        (y.GraphBase.read,True),

    ])).add_properties([DocProperty.evoke(*a) for a in [
        ('edges', y.GraphBase.edges), 
        ('nodes', y.GraphBase.nodes), 
        ('graph', y.GraphBase.graph),
        ('directed', y.GraphBase.directed, 'True if directed, False if not. Read-only.'),
        ('strict', y.GraphBase.strict, 'True if strict, False if not.  Read-only.'),
    ]])

    Graph = DocClass('Graph', (GraphBase,), y.Graph.__doc__).add_methods(map(DocFunction.evoke, [
        y.Graph.__init__,
    ]))

    Digraph = DocClass('Digraph', (GraphBase,), y.Digraph.__doc__).add_methods(map(DocFunction.evoke, [
        y.Graph.__init__,
    ]))

    Edge = DocClass('Edge', None, y.Edge.__doc__).add_properties([DocProperty.evoke(name,prop) for name,prop in [
        ('head', y.Edge.head),
        ('tail', y.Edge.tail),
        ('__iter__', y.Edge.__iter__),
        ('graph', y.Edge.graph),
    ]]).add_methods(map(DocFunction.evoke, [
        y.Edge.__iter__, 
    ]))
    Node = DocClass('Node', None, y.Node.__doc__).add_properties([DocProperty.evoke(name,prop) for name,prop in [
        ('edges', y.Node.edges),
        ('outbound_edges', y.Node.outbound_edges),
        ('inbound_edges', y.Node.inbound_edges),
        ('graph', y.Node.graph),
        ('__sub__', y.Node.__sub__),
        #('__cmp__', y.Node.__cmp__),  # causes epydoc to implode for some odd reason
        ('__lshift__', y.Node.__lshift__),
        ('__rshift__', y.Node.__rshift__),
    ]]).add_methods(map(DocFunction.evoke, [
    ]))

    
    Subgraph = DocClass('Subgraph', (GraphBase,), None)
    ClusterSubgraph = DocClass('ClusterSubgraph', (Subgraph,), None)

    implement_pseudograph_attributes(GraphBase,ClusterSubgraph,Node,Edge,Subgraph)
    
    package.init.entities += [
        GraphBase,
        Graph,
        Digraph,
        Edge,
        Node,
#        DocFunction.evoke(y.yapgvb_to_bgl),
#        DocFunction.evoke(y.bgl_to_yapgvb),
    ]
    
    package.write()

if __name__ == '__main__':
    # go about creating yapgvb documentation
    create_yapgvb_pseudomod()
    os.environ['PYTHONPATH'] = 'pseudomod'
    os.system('epydoc --debug --html -o doc -n yapgvb yapgvb')

