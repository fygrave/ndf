#!/usr/bin/env python


# 
# This file is a part of the Yapgvb software package, and is 
# licensed under the New BSD License.
# A `LICENSE' file should have been included with this source.
#
# Copyright (c) 2009 Lonnie Princehouse
#

# Use the Boost.Graph library bindings to find the minimum spanning
# tree of a randomly generated graph.

# yapgvb and boost.graph each have their own graph representations;
# this example demonstrates how to convert between the different formats.

# Note that you must have the Boost.Graph python bindings installed 
# for this example to work.

import yapgvb

def random_weighted_graph(nnodes=15, nedges=50):
    " Create a random graph using yapgvb "
    import random
    g = yapgvb.Graph()
    nodes = [g.add_node(str(i)) for i in xrange(nnodes)]
    random_node = lambda: random.choice(nodes)
    edges = [ (random_node() - random_node()) for j in xrange(nedges) ]
    for edge in edges:
        edge.weight = random.random()
    return g

if __name__ == '__main__':
    import boost.graph as bgl
	
    print "Generating a random graph..."
    graphviz_graph = random_weighted_graph()
    
    print "Converting graph representation to Boost.Graph..."

    # We must explicitly specifiy the edge and node properties 
    # which will be converted into Boost.Graph property maps.
    # In this case, we're only interested in the edge weights.
    bgl_graph, translation_map = graphviz_graph.to_bgl(edge_properties = ['weight'])
    
    # the returned translation_map is used to translate between the two
    # graph formats:
    #   translation_map[boost_vertex]  => corresponding yapgvb node
    #   translation_map[boost_edge]    => corresponding yapgvb edge
    #   translation_map[yapgvb_node]   => corresponding boost vertex
    #   translation_map[yapgvb_edge]   => corresponding boost edge
    
    weight_map = bgl_graph.edge_properties['weight']

    # Compute the minimum spanning tree of the graph
    # Returns a list of boost edges
    mst_edges = bgl.kruskal_minimum_spanning_tree(bgl_graph, weight_map)

    # Color the minimum spanning tree edges red in the graphviz representation
    for bgl_edge in mst_edges:

        # Get the yapgvb edge corresponding to the boost edge
        graphviz_edge = translation_map[bgl_edge]
        
        graphviz_edge.color = yapgvb.colors.red
    
    print "Using dot for layout..."
    graphviz_graph.layout(yapgvb.engines.dot)

    print "Rendering mst.png..."
    graphviz_graph.render('mst.png')

