# require models
# we _could_ do something clever to require everything in the models directory,
# but that seems like overkill for two files. If the project were to get bigger
# we could require everything in one line like this:
# Dir
#   .glob(File.join(File.dirname(__FILE__), 'models', '*'))
#   .each {|model| require model }

require './models/driver'
require './models/trip'

##
# represents an entire file of commands.
# Example format: (taken from problem statement)
# Driver Dan
# Driver Alex
# Driver Bob
# Trip Dan 07:15 07:45 17.3
# Trip Dan 06:12 06:32 21.8
# Trip Alex 12:01 13:16 42.0

# each line contains a command followed by some attributes
# Driver: represents a driver to register followed by the Drive's unique name.
# assume that names will be a unique identifier for drivers
# (only one driver named Dan for example)

# Trip: represents a single trip taken by a driver.
# the following fields are (in order):
# Driver's name
# trip start time (24 time)
# trip start time (24 time)
# miles driven
class CommandFile
  attr_accessor :file_loc

  ##
  # creates a new instance representing a command file
  # file_loc: relative path to the command file to use
  def initialize(file_loc)
    @file_loc = file_loc
  end # initialize

  ##
  # iterates over each line in the command file and loads all data found into
  # the database. An ArgumentError is raised if a line is empty or contains an
  # improper argument. If file_loc is not a valid path an error is raised when
  # trying to open the file. Errors produced by the Trip or Driver models will
  # not be caught

  # this method is only one line too long and I couldn't think of a way to
  # refactor in a way that wasn't unnecessarily messy
  def process
    # if the file does not exist the error will happen here
    File.open(@file_loc).each_with_index do |line, idx|
      # send the line of data to the right method for handling
      command = line.split[0]
      valid_command = %w[Driver Trip].include? command # is this command valuid?
      unless valid_command
        raise ArgumentError, "invalid command on line #{idx + 1}: '#{command}'"
      end
      # send line to the right method for processing
      send("process_#{command.downcase}", line)
    end # open
  end # process

  ##
  # outputs full driver report to console
  def report
    Driver.report.each { |line| puts line }
  end

  private

  ##
  # processes the driver by creating a record for that driver in the database
  # validation errors should cause an exception to be raised
  def process_driver(line)
    driver_name = line.split[1]
    Driver.create! name: driver_name
  end

  ##
  # processes the trip by creating a record for that trip in the database
  # validation errors should cause an exception to be raised
  def process_trip(line)
    # grab all attributes except the first one
    driver_name, start_time_str, end_time_str, miles_driven = line
                                                              .split
                                                              .slice(1, 4)

    # convert start/end time from String to Time
    start_time, end_time = [start_time_str, end_time_str]
                           .map { |str| Time.strptime str, '%H:%M' }

    # find the driver record this line references
    driver = Driver.find_by_name! driver_name

    # create the trip
    Trip.create!(driver_id: driver.id,
                 start_time: start_time,
                 end_time: end_time,
                 miles_driven: miles_driven.to_f)
  end
end
