#!/usr/bin/ruby

#created by mhassan772
#This parser will get you the title and how to check the finding. You may uncomment the fix part to get the fix too.
#You wil need to install nokogiri gem | sudo gem install nokogiri

#Shows how to use the script
def usage()
  puts "Usage is:"
  puts "#{__FILE__} path/to/STIG/file.xml"
  puts
end

file_location = ARGV[0]

#Checks if a parameter is typed or -h
if ARGV.empty? || file_location == "-h"
  usage
  exit
end

#nokogiri is for parsing xml
require 'nokogiri'
#spreadsheet is for creating spreadsheets like xls files
require 'spreadsheet'

#Open file to read XML with exception handling!
begin
  f = File.read(file_location)
rescue
  puts "File not found!"
end
#We can use doc = File.open("blossom.xml") { |f| Nokogiri::XML(f) }
#As a one line to open the file and put it in doc variable
doc = Nokogiri::XML(f)

book = Spreadsheet::Workbook.new
sheet1 = book.create_worksheet
sheet1.row(0).concat %w{ Title Check}
i = 1
#Begin writing each row
groups_xml =
doc.css('Group').each do |node|
  title = "#{node.css('Rule').css('title')}"
  title.slice! "<title>"
  title.slice! "</title>"

  check = "#{node.css('Rule').css('check').css('check-content')}"
  check.slice! "</check-content>"
  check.slice! ("<check-content>")

  sheet1.row(i).push title, check
  i+=1

  #fix = "#{node.css('Rule').css('fixtext')}"
  #fix.slice! "</fixtext>"
  #fix.slice! (/<fixtext fixref=\"F-.*_fix\">/)
  #puts "The fix is: "
  #puts fix


  #puts "######################################"
  #puts "######################################"
end
book.write 'testing.xls'

