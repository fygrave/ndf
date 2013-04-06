/*
* 
* This file is a part of the Yapgvb software package, and is 
* licensed under the New BSD License.
* A `LICENSE' file should have been included with this source.
*
* Copyright (c) 2009 Lonnie Princehouse
*
*/

#ifndef _yapgvb_defined
#define _yapgvb_defined

#include <iostream>
#include <boost/python.hpp>
#include <boost/python/str.hpp>
#include <boost/python/enum.hpp>
#include <boost/python/return_value_policy.hpp>
#include <boost/python/manage_new_object.hpp>


#include <types.h>
#include <graph.h>
#include <gvc.h>

#include <boost/shared_ptr.hpp>

using namespace boost::python;
using namespace boost;

#include <string.h>

void stop_iteration ();

enum agraph_type { 
    agraph = AGRAPH, 
    agraphstrict = AGRAPHSTRICT, 
    agdigraph = AGDIGRAPH,
    agdigraphstrict = AGDIGRAPHSTRICT,
};

// Magical function to reattach graphviz labout attributes to the dictionary
// structures.  Not listed in any headers because it might go away someday.

extern "C" {
void attach_attrs(Agraph_t* g);
};

char *extract_str (str s);

void py_aginit ();

class AttributeSymbol {
    Agsym_t *sym;
  public:
    AttributeSymbol (Agsym_t *s);
    bool valid ();
    int index ();
    void assert_validity ();
};

template <class T>
class AttributeContainer {
  protected:
    T *ptr;
    void set (T *p);
  public:
    AttributeContainer ();
    AttributeContainer (T *p);
    T *get();
    
    long hash();

    object get_attribute (AttributeSymbol *s);
    int set_attribute (AttributeSymbol *s, object value);

    AttributeSymbol *find_attribute ( str attribute_name ); 
};
     
//class Node;

class Graph;
class Node;

class Edge : public AttributeContainer<Agedge_t> {
  public:
      Edge (Agedge_t *e);
      Node *get_head();
      Node *get_tail();
};

class Node : public AttributeContainer<Agnode_t> { 
  private:
      Agraph_t *graph();
  public:
      Node (Agnode_t *n);
      PyObject *get_name ();
      Edge *first_edge ();
      Edge *first_inbound_edge ();
      Edge *next_inbound_edge (Edge *a);
      Edge *first_outbound_edge ();
      Edge *next_outbound_edge (Edge *a);
      Edge *next_edge (Edge *a);
      Graph *get_graph ();
};



class Graph : public AttributeContainer<Agraph_t> {
  private:
    bool _is_subgraph;
    bool destroy;
    bool auto_attach;
  public:
    Graph (); 
    Graph (FILE *instream); // : AttributeContainer<Agraph_t>();
    Graph (str name); // : AttributeContainer<Agraph_t>();
    Graph (str name, agraph_type type); // : AttributeContainer<Agraph_t>();
    Graph (Agraph_t *g, bool is_a_subgraph); // : AttributeContainer<Agraph_t> (g);
    Graph (Agraph_t *g); // : AttributeContainer<Agraph_t> (g);
    ~Graph ();
    
    void debug_render();
    void debug_file(FILE *f);

    bool points_to_same_graph (Graph *o);

    Node *node (str name);
    Node *find_node (str name);

    Edge *edge (Node *a, Node *b);
    
    Graph *subgraph (str name);

    int write(FILE *f);
    
    AttributeSymbol *declare_graph_attribute(str attribute_name, str default_value);
    
    AttributeSymbol *declare_node_attribute(str attribute_name, str default_value);

    AttributeSymbol *declare_edge_attribute(str attribute_name, str default_value);
    
    void set_destroy(bool x);

    PyObject *get_name ();
   
    Edge *find_edge (Node *a, Node *b);

    Node *first_node ();

    Node *last_node ();

    Node *next_node (Node *a);

    Node *previous_node (Node *a);

    void attach();

    void set_auto_attach(bool a);
    bool get_auto_attach();

    bool is_directed();
    bool is_strict();
    bool is_subgraph();
};



class GVCWrapper {
    GVC_t *gvc;
  public:
    // Default constructor
    GVCWrapper();
    
    int layout(Graph *graph, str engine);
    
    int render(Graph *graph, str fmt, FILE *outstream);

    // Linking to the pre-compiled graphviz library is causing render to not work
    // on FILE objects which boost has extracted from Python file objects.
    // 
    // Instead of getting to the bottom of this problem, I'm just going to
    // overload the function in Python and open the file in C. 
    //
    // Maybe someone who actually uses Windows would want to fix this properly?
    int render_windows_workaround(Graph *graph, str fmt, str out_filename);

    int freeLayout (Graph *graph);
};

struct pyfile_to_FILE
{
    static FILE& execute(PyObject& o)
    {
            return *PyFile_AsFile(&o);
    }
};

#endif
