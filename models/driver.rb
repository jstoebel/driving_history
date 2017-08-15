require 'active_record'
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
  # generate a report on all drivers 
  def self.report
    # generate aggregate for miles_driven and drive_time
    # example structure: {"Driver1"=>total_value, "Driver2"=>total_value}
    trips_by_driver_name = self
      .left_joins(:trips)
      .group(:name)

    # a 2d array with each inner array containing driver and total miles sorted by miles in decending order
    # example: [["Megan", 90.0], ["Jacob", 60.0]]
    miles_aggregate = trips_by_driver_name
      .sum(:miles_driven)
      .sort_by{|_key, value| -value} # sort resulting hash in decending order

    # a hash mapping driver name to total time driven
    # example: {"Jacob"=>60.0, "Megan"=>90.0}
    time_aggregate = trips_by_driver_name
      .sum(:drive_time)

    # desired output: Alex: 42 miles @ 34 mph

    # map data to array, where each item is a single driver's report string
    driver_reports = miles_aggregate.each_with_index.map do |driver_miles_array, idx|
      # driver_miles_array example: ["Jacob", 60.0]
      driver_name, driver_miles = driver_miles_array

      driver_time = time_aggregate[driver_name] # find this driver's total drive time
      
      if driver_miles == 0 || driver_time == 0
        mph_to_display = ""
      else
        driver_mph = (driver_miles / driver_time).round
        # should mph be displayed? No, if its 0
        mph_to_display = " @ #{driver_mph} mph"

      end
      "#{driver_name}: #{driver_miles.round} #{'mile'.pluralize(driver_miles.round)}#{mph_to_display}"

    end

    driver_reports.join("\n") # join into a string and return

  end
end