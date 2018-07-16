# jamf-ruby-tools
Some ruby scripts for jamf administration tasks. You need to edit them to add your server's URL, port, API user name, and password. 

  create_static_group_by_serial.rb: This is a fairly simple Ruby script that leverages the jamf API to create a Static Group from a list of serial numbers. When it runs it asks you for a unique name, checks this name to make sure it is available, and then parses the list for matches to add to the group. If it does not match a serial it will write it out to a text file, /tmp/missing_serials.txt, so you can take any necessary action on those numbers.

  computer_serial_check.rb: This is useful if you have a list of computers that need verification of enrollment. It will parse a specified list, look them up in the jamf server, and then write the results back to a .csv file on your Desktop.
  
  
