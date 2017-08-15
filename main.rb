require 'rubygems'
require 'bundler'
Bundler.require(:default, :development)

require './command_file'
require './schema'

file_loc = ARGV[0]

command_file = CommandFile.new file_loc
p command_file.process
