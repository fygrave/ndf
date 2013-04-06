#!/usr/bin/env python

# This file is a part of the Yapgvb software package, and is 
# licensed under the New BSD License.
# A `LICENSE' file should have been included with this source.
#
# Copyright (c) 2009 Lonnie Princehouse
#

# clique.py
# ---------
# Use yapgvb to generate, layout, and plot a clique.

import sys, yapgvb

def generate_clique (n = 10):
    """ create a clique of n nodes """
    
    # Create a new undirected graph
    graph = yapgvb.Graph('%s-clique' % n)
    
    # Generate n nodes
    for i in xrange(n):

        # Create new node
        node = graph.add_node(label = i)
        
        # Make an edge between the new node
        # and all other nodes
        for other in graph.nodes:
            if other != node:
                node - other
        
    return graph 

if __name__ == '__main__':
    # If the user supplied a command-line argument, try 
    # to interpret it as the number of nodes in the clique
    try:
        n = int(sys.argv[1])
    except:
        n = 10
    
    print "Generating an %s-clique ..." % n

    clique = generate_clique (n)

    print "Performing layout with circo ..."
    # Use circo for layout
    clique.layout(yapgvb.engines.circo)

    # Write to a file
    format = yapgvb.formats.png
    filename = '%s-clique.%s' % (n, format)

    print "Rendering %s ..." % filename
    clique.render(filename)

