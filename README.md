ndf
===

Network Defender Toolkit - a set of network tools for Enterprise Defense.

Documentation
-------------
Please see our presentation at HITBAMS2013.
Also available in ./presentation/

Requirements
------------
* python
* perl

specific requirements are outlined in documentation for each particular tool.


Overview of the tools
---------------------

* proxy analyzer - proxy logs tool analyzer designed to identify potential malicious activities (drive by download attacks, botnet c2 communication and so on) within
enterprise proxy ogs

* dns tools - a set of tools for dns traffic analysis

* anomalizer - anomaly detection mechanics

* ryocrawler - proactive "Roll Your Own" network crawler. built to identify potential Drive by Download attack points. (utilizes jsunpack and Yara for rapid content analysis)

* SEC-rules - a set of SEC.pl rules for different purposes

* update_macs - set of tools for matching user IDs and trace location changes

* mlogparser - wrapper for MS' logparser to store windows logs in DB


Authors
-------------------
* Vladimir Kropotov
* Segey Soldatov
* Fyodor Yarochkin
