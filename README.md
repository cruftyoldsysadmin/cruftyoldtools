### cruftyoldtools

A repository of DevOps scripts and configurations in Ruby, Bash, Python, Puppet, and AWS.


### stackdriver-maintenance-mode.rb

Queries the deprecated (v0.2, pre-google) stackdriver API to report on which instances are currently set to maintenance mode.

##### Requirements: 
* Ruby 2.4 ( Has not been tested on any earlier version )
* HTTPClient gem (tested against version 2.8.3)
* Stackdriver V1 API key (Place this in the API section of the script)
