# jamf-ruby-tools
Some ruby scripts for jamf administration tasks

  create_static_group_by_serial.rb: This is a fairly simple Ruby script that leverages the jamf API to create a Static Group from a list of serial numbers. You need to edit it to add your server's URL, port, API user name, and password. When it runs it asks you for a unique name, checks this name to make sure it is available, and then parses the list for matches to add to the group. If it does not match a serial it will write it out to a text file, /tmp/missing_serials.txt, so you can take any necessary action on those numbers.
