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
  # example:
  #   Megan: 60 miles @ 50 mph
  #   Jacob: 45 miles @ 30 mph
  def self.report
    # generate aggregate for miles_driven and drive_time
    # example structure: {"Driver1"=>total_value, "Driver2"=>total_value}
    trips_by_driver_name = left_joins(:trips).group(:name)

    # a 2d array with each inner array containing driver and total miles sorted
    # by miles in decending order
    # example: [["Megan", 90.0], ["Jacob", 60.0]]
    miles_aggregate = trips_by_driver_name.sum(:miles_driven)
                                          .sort_by { |_key, value| -value }

    # a hash mapping driver name to total time driven
    # example: {"Jacob"=>60.0, "Megan"=>90.0}
    time_aggregate = trips_by_driver_name.sum(:drive_time)

    # desired output: Alex: 42 miles @ 34 mph

    # map data to array, where each item is a single driver's report string
    driver_reports = miles_aggregate.each.map do |driver_miles_array|
      # driver_miles_array example: ["Jacob", 60.0]
      driver_name, miles = driver_miles_array # unpack array into name and miles
      total_time = time_aggregate[driver_name] # get total_time for this driver
      driver_report driver_name, miles, total_time
    end
    # driver_reports.join("\n") # join into a string and return
  end

  ##
  # generate a report on a single driver
  # name: (str) driver's name
  # miles (float) miles driven by driver
  # total_time (float): total_time driven
  # 0 trips
  def self.driver_report(driver_name, miles, total_time)
    base_str = "#{driver_name}: #{miles.round} #{'mile'.pluralize(miles.round)}"

    if total_time.zero?
      mph_to_display = ''
    else
      mph = miles / total_time
      mph_to_display = " @ #{mph.round} mph"
    end
    base_str + mph_to_display
  end
end
