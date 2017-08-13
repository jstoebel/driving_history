require 'rubygems'
require 'bundler'

require './command_file'
require './schema'

file_loc = ARGV[0]

command_file = CommandFile.new file_loc
command_file.process