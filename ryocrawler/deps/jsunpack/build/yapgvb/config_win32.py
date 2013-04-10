from config_generic import *



# Everything below this line is irrelevant if use_boost = False
# --------------------------------------------------------------------


#
# It's a huge headache to maintain the boost backend on Windows,
# so only the pure-python backend is supported.  If you want to
# try to compile the boost backend, set use_boost = True in this file.
#

# Edit this to reflect the location of your boost root directory
boost_location = 'c:/docume~1/administrator/desktop/boost_1_33_1/boost_1_33_1'

# You will probably need to edit this to point to your compiled boost dll directory
boost_python_dll_location = boost_location + '/bin/boost/libs/python/build/boost_python.dll/vc-7_1/release/threading-multi'


# Complete path of the boost python dll.  We will need to bundle it with our distribution 
# since Windows users can't be expected to have boost installed.
boost_python_dll_path = boost_python_dll_location + '/boost_python-vc71-mt-1_33_1.dll'
boost_python_dll_path = boost_python_dll_path.replace('/','\\')

# bundle boost python dll along with the distribution
data_files = [('lib/site-packages/yapgvb', [boost_python_dll_path])]

library_dirs = [
    # Default installation location for Graphviz libraries
    'c:/progra~1/att/graphviz/lib',    
    boost_python_dll_location,
]

include_dirs = [
    # Default installation for Graphviz headers
    'c:/progra~1/att/graphviz/include',  
    # Parent directory of boost/ header directory
    boost_location,
]

libraries = [
    'boost_python-vc71-mt-1_33_1',  # Edit this to reflect the name of your Boost Python dll
    'libc',  # We need to link to libc because the graphviz binaries link to it
    # ------ Graphviz 2.8 libraries ---------------------

    # we only call functions from graph, cdt, and gvc...
    'graph',
    'cdt',
    'gvc',
    
    # ... but since they're statically linked, we need to link to the rest of the graphviz libs too
    'circogen',
    'common',
    'dotgen',
    'fdpgen',
    'ft',
    'gd',
    'ingraphs',
    'jpeg',
    'libexpat',
    'libexpatw',
    'libz',
    'neatogen',
    'pack',
    'pathplan',
    'plugin',
    'png',
    'twopigen',
    'z',
]

extra_link_args = ['/NODEFAULTLIB:msvcrt','/FORCE']
