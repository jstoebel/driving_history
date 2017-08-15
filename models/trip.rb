require 'active_record'
require 'active_support/inflector'
## 
# represents a single trip
# Table name: Trip
# driver_id(integer) references a driver
# state_time(datetime) begining time of the trip
# end_time(datetime) end time of the trip
# drive_time(float): number of hours drive
# miles_driven(float) the number of miles driven

class Trip < ActiveRecord::Base

  belongs_to :driver

  validates :driver_id,
    presence: true,
    numericality: true

  validates :start_time,
    presence: true

  validates :end_time,
    presence: true

  validates :miles_driven,
    presence: true,
    :numericality => {:greater_than => 0}

  # compute the drive_time if the record passes validation (needs to have a start and end time)
  after_validation :get_drive_time, :if => Proc.new { |t| !t.errors.any? }

  private

  ##
  # computes the drive time of the trip
  # if the average speed is less than 5 or more than 100 its not valid
  def get_drive_time

    self.drive_time = (end_time - start_time) / 3600 # compute drive time
    avg_speed =  miles_driven / self.drive_time # compute average_speed

    # add an errors if < 5 or > 100 mph

    if avg_speed < 5.0
      self.errors.add(:base, "average speed is too slow (< 5 mph).")
    elsif avg_speed > 100.0
      self.errors.add(:base, "average speed is too fast (> 100 mph).")
    end
  end

end