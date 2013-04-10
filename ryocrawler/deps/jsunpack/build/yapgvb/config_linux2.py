
use_boost = True


library_dirs = [
    # Location of Graphviz libraries
    '/usr/lib/graphviz',   
    # Location of libboost_python.so
    '/usr/local/lib',
]

include_dirs = [
    # Location of Graphviz headers
    '/usr/include/graphviz',
    # Location of boost/ header directory
    '/usr/local/include',
]

libraries = [   
    'boost_python',
    # ------ Graphviz libraries (tested against GV 2.6 shared libraries ... the libraries may differ for 2.8 or static .libs)
    'graph',
    'cdt',
    'gvc',
]

extra_link_args = []

data_files = []
