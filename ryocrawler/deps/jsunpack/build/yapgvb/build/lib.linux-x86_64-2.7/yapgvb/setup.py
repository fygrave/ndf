#!/usr/bin/env python
#
# 
# This file is a part of the Yapgvb software package, and is 
# licensed under the New BSD License.
# A `LICENSE' file should have been included with this source.
#
# Copyright (c) 2009 Lonnie Princehouse
#
#
# The Boost.Python part of this script is based on Daniel Holth's setup script for shoutpy, 
# a Boost.Python binding for libshout 2: http://dingoskidneys.com/shoutpy/
#

from distutils.core import setup

# local configuration
import config

import sys, os

parent_dir = os.path.split(os.path.split(__file__)[0])[0]
sys.path.insert(0,parent_dir)

description = """Python bindings for Graphviz, using Boost.Python."""

classifiers="""
Development Status :: 3 - Alpha
License :: New BSD (see included LICENSE file)
Operating System :: POSIX :: Linux
Programming Language :: C++
Programming Language :: Python
Topic :: Software Development :: Libraries :: Python Modules
"""

version="1.2.3"

url = "http://sourceforge.net/projects/yapgvb"

setup_args = dict(
    name="yapgvb",
    version=version,
    description="Yet Another Graphviz Binding",
    long_description=description,
    author="Lonnie Princehouse",
    author_email="finite.automaton@gmail.com",
    url=url,
    license="New BSD",
    packages = ['yapgvb','yapgvb.examples'],
    package_dir = {'yapgvb':''},
    classifiers=filter(None, classifiers.splitlines()),
)

if config.use_boost:
    from distutils.extension import Extension
    setup_args['ext_modules'] = [Extension("yapgvb._yapgvb", ["_yapgvb.cpp"],
                             libraries=config.libraries,
                             extra_link_args=config.extra_link_args,
                             include_dirs=config.include_dirs,
                             library_dirs=config.library_dirs)]
    setup_args['data_files'] = config.data_files


setup(**setup_args)

