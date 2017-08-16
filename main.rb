require 'rubygems'
require 'bundler'
require 'active_record'

require './command_file'
require './schema'

file_loc = ARGV[0] # get file path from command line argument

# process the data and report the results
command_file = CommandFile.new file_loc
command_file.process
command_file.report
