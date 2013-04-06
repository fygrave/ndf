import sys




# If you're using Windows, edit config_win32.py
# Otherwise edit config_unix.py

try:
    platform_config_module = 'config_%s' % sys.platform
    exec("from %s import *" % platform_config_module)
except ImportError:
    from config_generic import *

