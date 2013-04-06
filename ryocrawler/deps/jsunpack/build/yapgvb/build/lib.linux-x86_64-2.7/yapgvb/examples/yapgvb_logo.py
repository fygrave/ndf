#!/usr/bin/env python

# 
# This file is a part of the Yapgvb software package, and is 
# licensed under the New BSD License.
# A `LICENSE' file should have been included with this source.
#
# Copyright (c) 2009 Lonnie Princehouse
#

# A silly example to generate the logo for the yapgvb homepage

import yapgvb

if __name__ == '__main__':
    g = yapgvb.Digraph('yapgvb_logo')
    
    yapgvb_node = g.add_node("YAPGVB",
        label = 'YAPGVB',
        shape = yapgvb.shapes.doublecircle,
        color = yapgvb.colors.blue,
        fontsize = 48)

    last_word = None
    
    for word in "Yet Another Python Graphviz Binding".split():
        word_node = g.add_node(word,
            label = word,
            fontsize = 24,
            shape = yapgvb.shapes.circle)
    
        if last_word:
            last_word >> word_node
        else:
            yapgvb_node >> word_node

        last_word = word_node
        
        for i,character in enumerate(word):
            charnode = g.add_node("%s%s" % (word,i),
                label = character,
                fontsize = 12,
                shape = yapgvb.shapes.circle)

            word_node >> charnode

    yapgvb_node << word_node

    g.layout(yapgvb.engines.circo)
    g.render('yapgvb_logo.svg')
    g.render('yapgvb_logo.jpg')
