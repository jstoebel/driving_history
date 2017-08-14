require 'active_record'
require 'active_support/inflector'
##
# represents a single driver
# Table name: driver
#
#  name(string)

class Driver < ActiveRecord::Base

  has_many :trips
  
  validates :name,
    presence: true,
    uniqueness: true

  ##
  # returns a hash containing:
    # toal_miles: total miles driven for user
    # output_str: an output string reporting driver name, miles driven and average speed
      # example format: Jacob: 33 miles @ 42 mph
  def report

    total_miles = trips.sum(:miles_driven)
    total_drive_time = trips.sum(:drive_time)
    avg_speed = total_miles / total_drive_time

    
    {
      avg_speed: avg_speed,
      report_str: "#{name}: #{total_miles} #{'miles'.pluralize(total_miles)} @ #{avg_speed > 0 ? } mph"
    }

  end

end