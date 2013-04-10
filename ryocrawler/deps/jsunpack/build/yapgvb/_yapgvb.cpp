/*
* 
* This file is a part of the Yapgvb software package, and is 
* licensed under the New BSD License.
* A `LICENSE' file should have been included with this source.
*
* Copyright (c) 2009 Lonnie Princehouse
*
*/


#include <iostream>
#include <boost/python.hpp>
#include <boost/python/str.hpp>
#include <boost/python/enum.hpp>
#include <boost/python/return_value_policy.hpp>
#include <boost/python/manage_new_object.hpp>


// (no, this isn't sys/types.h ... it's the types.h from graphviz/include)
#include <types.h>

#include <graph.h>
#include <gvc.h>

#include <boost/shared_ptr.hpp>

#include "_yapgvb.hpp"

using namespace boost::python;
using namespace boost;

#include <string.h>

// Forward declarations!

void stop_iteration ()
{
    PyErr_SetString( PyExc_StopIteration, "Stop Iteration");
    throw_error_already_set();
}    

char *extract_str(str s)
{
    return PyString_AsString(s.ptr()); 
}

void py_aginit () {
    static bool aginit_has_been_called = false;
    if(!aginit_has_been_called) {
        aginit();
        aginit_has_been_called = true;
    }
}


AttributeSymbol::AttributeSymbol(Agsym_t *s) 
{ 
    sym = s; 
}

bool AttributeSymbol::valid () 
{ 
    return sym != NULL; 
}

int AttributeSymbol::index () 
{ 
    assert_validity();
    return sym->index; 
}   

void AttributeSymbol::assert_validity ()
{
    if(!valid()) {
        PyErr_SetString( PyExc_KeyError, "Invalid symbol");
        throw_error_already_set();
    }
}

template <class T>
void AttributeContainer<T>::set (T *p)
{
    ptr = p;
}

template <class T>
AttributeContainer<T>::AttributeContainer () 
{ 
    ptr = NULL; 
}

template <class T>
AttributeContainer<T>::AttributeContainer (T *p) { 
    ptr = p; 
}

template <class T>
T *AttributeContainer<T>::get() { 
    return ptr; 
}

template <class T>
long AttributeContainer<T>::hash() {
    return long(ptr);
}

template <class T>
object AttributeContainer<T>::get_attribute(AttributeSymbol *s)
{
    char *value = agxget( (void *) ptr, s->index() );
    if(value == NULL) 
        return object();            
    else
        return str( (char const *) value);
}

template <class T>
int AttributeContainer<T>::set_attribute(AttributeSymbol *s, object value)
{
    return agxset( (void *) ptr, s->index(), extract_str(str(value)));
}

template <class T>
AttributeSymbol *AttributeContainer<T>::find_attribute ( str attribute_name ) 
{
    AttributeSymbol *s = new AttributeSymbol( agfindattr ( (void *) ptr, extract_str(attribute_name)));
    s->assert_validity();
    return s;
}
     
Edge::Edge (Agedge_t *e) : AttributeContainer<Agedge_t> (e) {}


Node *Edge::get_head () 
{ 
    return new Node(get()->head); 
}

Node *Edge::get_tail() 
{ 
    return new Node(get()->tail); 
}


Agraph_t *Node::graph()
{
    return get()->graph;
}

Graph *Node::get_graph()
{
    Graph *g = new Graph(graph());
    g->set_destroy(false);
    return g;
}

Node::Node (Agnode_t *n) : AttributeContainer<Agnode_t> (n) {}

PyObject *Node::get_name () 
{ 
    return PyString_FromString(get()->name); 
}
    
Edge *Node::first_edge () 
{
    Agedge_t *e = agfstedge(graph(), get());
    if(e==NULL) 
    {
        PyErr_SetString( PyExc_IndexError, "Node has no edges");
        throw_error_already_set();
    }
    return new Edge(e);
}

Edge *Node::first_inbound_edge () 
{
    Agedge_t *e = agfstin(graph(), get());
    if(e==NULL) 
    {
        PyErr_SetString( PyExc_IndexError, "Node has no edges");
        throw_error_already_set();
    }
    return new Edge(e);
}

Edge *Node::next_inbound_edge (Edge *a) 
{
    Agedge_t *e = agnxtin(graph(), a->get());
    if(e==NULL) stop_iteration();
    return new Edge(e);
}

Edge *Node::first_outbound_edge () 
{
    Agedge_t *e = agfstout(graph(), get());
    if(e==NULL) 
    {
        PyErr_SetString( PyExc_IndexError, "Node has no edges");
        throw_error_already_set();
    }
    return new Edge(e);
}

Edge *Node::next_outbound_edge (Edge *a) 
{
    Agedge_t *e = agnxtout(graph(), a->get());
    if(e==NULL) stop_iteration();
    return new Edge(e);
}


Edge *Node::next_edge (Edge *a) 
{
    Agedge_t *e = agnxtedge(graph(), a->get(), get());
    if(e==NULL) stop_iteration();
    return new Edge(e);
}




Graph::Graph () : AttributeContainer<Agraph_t>() {
    py_aginit();
    _is_subgraph = false;
    set(agopen("graph", AGRAPH));
}

void Graph::attach () { attach_attrs(get()); }

Graph::Graph (FILE *instream) : AttributeContainer<Agraph_t>() {
    py_aginit();
    _is_subgraph = false;
    set(agread(instream));
    if (get() == NULL)
    {
        PyErr_SetString( PyExc_Exception, "agread: I/O failure");
        throw_error_already_set();
    }
}

Graph::Graph (str name) : AttributeContainer<Agraph_t>() {
    py_aginit();
    _is_subgraph = false;
    set(agopen(extract_str(name), AGRAPH));
}

void Graph::set_destroy (bool x) { destroy = x; }

Graph::Graph (str name, agraph_type type) : AttributeContainer<Agraph_t>()
{
    py_aginit();
    _is_subgraph = false;
    set(agopen(extract_str(name), type));
}

Graph::Graph (Agraph_t *g, bool is_a_subgraph) : AttributeContainer<Agraph_t> (g)
{
    py_aginit();
    _is_subgraph = is_a_subgraph;
}
    
Graph::Graph (Agraph_t *g) : AttributeContainer<Agraph_t> (g)
{
    py_aginit();
    _is_subgraph = false;
}

bool Graph::get_auto_attach() { return auto_attach; }
void Graph::set_auto_attach(bool a) { auto_attach = a; }
Graph::~Graph ()
{
    if(destroy && get() != NULL && !_is_subgraph) agclose(get());
}
    
Node *Graph::node (str name)
{
    return new Node(agnode(get(), extract_str(name)));
}

Node *Graph::find_node (str name)
{
    Agnode_t *n;    
    n = agnode(get(), extract_str(name));
    if(n == NULL) {
        PyErr_SetString( PyExc_KeyError, "Node not found");
        throw_error_already_set();
    }
    return new Node(n);
}

Edge *Graph::edge (Node *a, Node *b)
{
    return new Edge(agedge(get(), a->get(), b->get()));       
}

Graph *Graph::subgraph (str name)
{
    return new Graph(agsubg(get(), extract_str(name)), true);
}


bool Graph::points_to_same_graph (Graph *o)
{   
    return get() == o->get();
}

int Graph::write(FILE *f)
{
    return agwrite(get(), f);
}

AttributeSymbol *Graph::declare_graph_attribute(str attribute_name, str default_value)
{
    return new AttributeSymbol(agraphattr(get(), extract_str(attribute_name), extract_str(default_value)));
}

AttributeSymbol *Graph::declare_node_attribute(str attribute_name, str default_value)
{
    return new AttributeSymbol(agnodeattr(get(), extract_str(attribute_name), extract_str(default_value)));
}

AttributeSymbol *Graph::declare_edge_attribute(str attribute_name, str default_value)
{
    return new AttributeSymbol(agedgeattr(get(), extract_str(attribute_name), extract_str(default_value)));
}

PyObject *Graph::get_name () { return PyString_FromString(get()->name); }

Edge *Graph::find_edge (Node *a, Node *b) {
    Agedge_t *e = agfindedge(get(), a->get(), b->get());
    if(e == NULL)
    {
        PyErr_SetString( PyExc_IndexError, "Graph contans no nodes");
        throw_error_already_set();
    }
    return new Edge(e);
}

Node *Graph::first_node () {
    Agnode_t *n = agfstnode(get());
    if(n == NULL)
    {
        PyErr_SetString( PyExc_IndexError, "Graph contans no nodes");
        throw_error_already_set();
    }
    return new Node(n);
}

Node *Graph::last_node () {
    Agnode_t *n = aglstnode(get());
    if(n == NULL)
    {
        PyErr_SetString( PyExc_IndexError, "Graph contans no nodes");
        throw_error_already_set();
    }
    return new Node(n);
}

Node *Graph::next_node (Node *a) {
    Agnode_t *n = agnxtnode(get(), a->get());
    if(n == NULL) stop_iteration();
    return new Node(n);
}

Node *Graph::previous_node (Node *a) {
    Agnode_t *n = agprvnode(get(), a->get());
    if(n == NULL) stop_iteration();
    return new Node(n);
}

bool Graph::is_directed()
{
    return AG_IS_DIRECTED(get());
}

bool Graph::is_strict()
{
    return AG_IS_STRICT(get());
}

bool Graph::is_subgraph()
{
    return _is_subgraph;
}

void Graph::debug_render()
{
    py_aginit(); 
    FILE *f = fopen("test.gif", "wb");
    GVC_t *gvc = gvContext();
    int result;
    result = gvLayout(gvc, get(), "dot");
    if(result)
        std::cout << "result of gvLayout non-zero: " << result << std::endl;         
    result = gvRender(gvc, get(), "gif", f);
    if(result)
        std::cout << "result of gvRender non-zero: " << result << std::endl;         
    fclose(f);    
}

void Graph::debug_file(FILE *f)
{
    fprintf(f, "THIS IS A TEST FILE!  BAH!\n");
}

GVCWrapper::GVCWrapper() 
{ 
    py_aginit();
    gvc = gvContext();
}
    
int GVCWrapper::layout (Graph *graph, str engine) {
    int result = gvLayout(gvc, graph->get(), PyString_AsString(engine.ptr()));
    if(graph->get_auto_attach()) graph->attach();
    return result;
}

int GVCWrapper::render (Graph *graph, str fmt, FILE *outstream)
{
    if(outstream == NULL)
    {   
        std::cerr << "Output stream for render call is NULL!" << std::endl;
        return -1;
    }
    return gvRender(gvc, graph->get(), PyString_AsString(fmt.ptr()), outstream);
}

int GVCWrapper::render_windows_workaround (Graph *graph, str fmt, str out_filename)
{
    char *fname = extract_str(out_filename);
    FILE *f = fopen(fname, "wb");
    int result = render (graph, fmt, f);
    fclose(f);
    return result;
}

int GVCWrapper::freeLayout (Graph *graph)
{
    return gvFreeLayout(gvc, graph->get());
}



BOOST_PYTHON_MODULE(_yapgvb)
{
    lvalue_from_pytype<pyfile_to_FILE, &PyFile_Type> ();
    class_<GVCWrapper>("RenderingContext")
        .def("layout", &GVCWrapper::layout)
        .def("render", &GVCWrapper::render) 
        .def("render", &GVCWrapper::render_windows_workaround)
        .def("free_layout", &GVCWrapper::freeLayout)
        ;
    class_<Graph>("CGraph")
        .def(init<str>())
        .def(init<str, agraph_type> ())
        .def(init<FILE *> ())
        .def("add_node", &Graph::node, 
            return_internal_reference<1> ())
        .def("add_edge", &Graph::edge,
            return_internal_reference<1> ())
        .def("write", &Graph::write)
        .def("declare_graph_attribute", &Graph::declare_graph_attribute, 
            return_internal_reference<1> ())
        .def("declare_node_attribute", &Graph::declare_node_attribute, 
            return_internal_reference<1> ())
        .def("declare_edge_attribute", &Graph::declare_edge_attribute, 
            return_internal_reference<1> ())
        .def("__get_attribute__", &Graph::get_attribute)
        .def("__set_attribute__", &Graph::set_attribute)
        .def("__find_attribute__", &Graph::find_attribute,
            return_internal_reference<1> ())
        .def("__points_to_same_graph__", &Graph::points_to_same_graph)
        .def("__hash__", &Graph::hash)
        .def("first_node", &Graph::first_node,
            return_internal_reference<1> ())
        .def("last_node", &Graph::last_node,
            return_internal_reference<1> ())
        .def("subgraph", &Graph::subgraph,
            return_internal_reference<1> ())
        .def("next_node", &Graph::next_node,
            return_internal_reference<1> ())
        .def("previous_node", &Graph::previous_node,
            return_internal_reference<1> ())
        .def("find_edge", &Graph::find_edge,  
            return_internal_reference<1> ())
        .def("find_node", &Graph::find_node,  
            return_internal_reference<1> ())
        .def("debug_render", &Graph::debug_render)
        .def("debug_file", &Graph::debug_file)
        .def("__attach__", &Graph::attach)
        .def("__set_auto_attach__", &Graph::set_auto_attach)
        .def("__get_auto_attach__", &Graph::get_auto_attach)
        .def("is_subgraph", &Graph::is_subgraph)
        // Properties
        .add_property ("name", &Graph::get_name)
        .add_property ("directed", &Graph::is_directed)
        .add_property ("strict", &Graph::is_strict)
        ;
    class_<Node>("Node", no_init)
        .def("__get_attribute__", &Node::get_attribute)
        .def("__set_attribute__", &Node::set_attribute)
        .def("__find_attribute__", &Node::find_attribute,
            return_internal_reference<1> ())
        .def("first_edge", &Node::first_edge,
            return_internal_reference<1> ())
        .def("next_edge", &Node::next_edge,
            return_internal_reference<1> ())
        .def("first_inbound_edge", &Node::first_inbound_edge,
            return_internal_reference<1> ())
        .def("next_inbound_edge", &Node::next_inbound_edge,
            return_internal_reference<1> ())
        .def("first_outbound_edge", &Node::first_outbound_edge,
            return_internal_reference<1> ())
        .def("next_outbound_edge", &Node::next_outbound_edge,
            return_internal_reference<1> ())
        .def("__get_graph__", &Node::get_graph,
            return_internal_reference<1> ())
        .def("__hash__", &Node::hash)
        // Properties
        .add_property ("name", &Node::get_name)
        ;

    class_<Edge>("Edge", no_init)
        .def("__get_attribute__", &Edge::get_attribute)
        .def("__set_attribute__", &Edge::set_attribute)
        .def("__find_attribute__", &Edge::find_attribute,
            return_internal_reference<1> ())
        .def("__get_head__", &Edge::get_head,
            return_internal_reference<1> ())
        .def("__get_tail__", &Edge::get_tail,
            return_internal_reference<1> ())
        .def("__hash__", &Edge::hash)
        ;
    class_<AttributeSymbol>("Attribute", no_init);

    enum_<agraph_type>("agraph_type")
        .value("AGRAPH", agraph)
        .value("AGRAPHSTRICT", agraphstrict)
        .value("AGDIGRAPH", agdigraph)
        .value("AGDIGRAPHSTRICT", agdigraphstrict) 
        .export_values()
        ; 

}   


           
