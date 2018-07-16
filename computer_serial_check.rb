=begin
computer_serial_check.rb
Written by Christopher Kemp for Accenture 
This script will take a list of serial numbers as input and check the JSS for their existence.
HUGE tip of the hat to Chris Lasell from Pixar for the tips on how to call the functions.
Input file should have no headers, just a list of computer names formatted as Unix LF.
=end 

# required libraries
require 'ruby-jss'
require 'csv'

###### Connection details ######
jamf_server="YOUR SERVER HERE"
jamf_port=8443 #edit if you use a non-standard port
jamf_user="YOUR API USER HERE"
jamf_pass="YOUR API PASS HERE"

# Prompt user for the input file to use
print "List of Serial Numbers: "
fileLoc = gets.strip

# Prompt for the file to write to
print "Name your report (.csv will be added): "
repName = gets.strip

# set path
myPath = Pathname.new '~/Desktop'
# set filename from expanded path and repName variable
myFile = myPath.expand_path + "#{repName}.csv"
# initialize placeholder for loop output
myFileContents 	= ''

# Connect to the jamf pro server
JSS::API.connect server: "#{jamf_server}" , port: "#{jamf_port}", use_ssl: true, ssl_version: 'TLSv1_2', timeout: 600, user: "#{jamf_user}", pw: "#{jamf_pass}" 

CSV.foreach("#{fileLoc}") do |row|
	item = row.first

  if JSS::Computer.all_serial_numbers.include? item
  puts "#{item}, found in JSS"
	nextLine = "#{item}, enrolled"
	myFileContents << "#{nextLine}\n"

	else
	puts	"#{item} not found..." 
	nextLine = "#{item}, missing"
	myFileContents << "#{nextLine}\n"

end

# write the report to the specified file
myFile.jss_save myFileContents

# Ends report generation, returns to menu
end
