visage
======

Visage is a web interface for viewing `collectd` statistics.

It also provides a JSON interface onto `collectd`'s RRD data. giving you an easy
way to mash up the data.

Installing
----------

Freeze in dependencies:

    $ rake deps

Running
-------

For development: 

    $ gem install shotgun
    $ shotgun sinatra-collectd.rb

Testing 
-------

Run all cucumber features: 

    $ rake cucumber 

Specific features: 

    $ bin/cucumber --require features/ features/something.feature

TODO
----

 * create proper mootools class - DONE
 * switch to g.raphael - DONE
 * config file - DONE
 * data profiles - DONE
 * handle single plugin instance in graphing code
 * specify data url in graphing code
 * nice scrollbars to specify start/end time. 
 * axis labels
 * combine graphs from different hosts
 * zoom + dynamic resize
 * comment on time periods
 * view list of comments
