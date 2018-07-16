=begin
create_static_group_by_serial.rb
Written by Christopher Kemp for Accenture
Massive Thank You! to Chris Lasell at Pixar for his guidance and for the ruby-jss module.

This script will create a Static Group in your jamf pro server from a list of serial numbers.
(Windows CRLF must be converted to Unix LF or it will fail!).
If it cannot find one of the serials it will log it to a text file at the end of the script.
=end

require 'ruby-jss'
require 'csv'

# Get the desired Group name
print "Name of Static Group to create: "
newGroup = gets.strip

jamf_server="YOUR SERVER HERE"
jamf_user="YOUR API USER HERE"
jamf_pass="YOUR API PASS HERE"

# create array for listing any missing serials
sn_fails = []

# Connect to the jamf pro server
JSS::API.connect server: "#{jamf_server}" , port: 443, use_ssl: true, ssl_version: 'TLSv1_2', timeout: 600, user: "#{jamf_user}", pw: "#{jamf_pass}" 

# Check that the name does not conflict with current groups
while JSS::ComputerGroup.all_names.include? newGroup
	print "Group name taken, please choose another name: "
	newGroup = gets.strip
end

# Get the list of computer names to populate the group
print "Location of Serial Number List: "
groupList = gets.strip

# Create new Static Group
pg = JSS::ComputerGroup.make name: newGroup, type: :static

# Read in Column 1 of the list of names and add them to the group
CSV.foreach("#{groupList}") do |row|
	sernum = row.first
	puts "trying serial number '#{sernum}'"
	jssid = JSS::Computer.map_all_ids_to(:serial_number).invert[sernum]
	unless jssid
    sn_fails << "#{sernum}\n"
    print "#{sernum} not found on jamf server.\n"
    next
  end
  print "Adding #{sernum}...\n"
  pg.add_member jssid
end
#Write failures to logfile
File.open("/tmp/missing_serials.txt", "w+") do |f|
	sn_fails.each { |element| f.puts(element) }
	end
# Write group to JSS
pg.save
print "#{newGroup} group created.\nAny entries not found have been logged to /tmp/missing_serials.txt\n\n"

