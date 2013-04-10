#!/usr/bin/env python

# 
# This file is a part of the Yapgvb software package, and is 
# licensed under the New BSD License.
# A `LICENSE' file should have been included with this source.
#
# Copyright (c) 2009 Lonnie Princehouse
#


# Make a graph of a directory's structure

# Usage:
#   graph_directory.py directory [output_file]

import yapgvb
import user, os, sys, operator

def generate_directory_graph(directory):
    # Create a new directed graph
    graph = yapgvb.Digraph(directory)
    
    # Traverse the directory structure
    nodes = {}
    try:
        for dirpath, dirnames, filenames in os.walk(directory):
            print "    ", dirpath

            parent_directory, dirname = os.path.split(dirpath)
            nfiles = len(filenames)

            # Create a new node for this directory
            nodes[dirpath] = graph.add_node(dirpath, 
                label = "%s: %s files" % (dirname, nfiles),
                shape = 'record',
            )
            
            if parent_directory in nodes:
                # create an edge between the parent directory node 
                # and the newly created node
                nodes[parent_directory] >> nodes[dirpath]            
    except KeyboardInterrupt:
        print '----> Directory traversal cancelled!'

    return graph        


if __name__ == '__main__':

    # Did the user specify a filename on the command line?
    args = sys.argv[1:]
    
    output_file = None
    try:
        directory, output_file = args
    except:
        try:
            directory = args[0]
        except:
            directory = user.home

    directory = os.path.abspath(directory)

    if output_file is None:
        output_file = os.path.split(directory)[-1] + '.png'
    
    print "Generating directory graph for %s... Ctrl-C to terminate" % directory

    graph = generate_directory_graph(directory)
        
    # layout with circo algorithm
    print "Using circo engine for layout..."
    graph.layout(yapgvb.engines.circo) 
    
    # render!
    print "Rendering %s..." % output_file
    graph.render(output_file)

