##
# represents a single trip
# Table name: trips
# driver_id(integer) references a driver
# state_time(datetime) begining time of the trip
# end_time(datetime) end time of the trip
# drive_time(float): number of hours driven
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
            numericality: { greater_than: 0 }

  # compute drive_time and validate avg speed if the record passes validation
  # (needs to have a start and end time)
  after_validation :compute_drive_time, if: proc { |trip| trip.errors.none? }
  after_validation :validate_avg_speed, if: proc { |trip| trip.errors.none? }

  private

  ##
  # returns the drive time of the trip
  def compute_drive_time
    self.drive_time = (end_time - start_time) / 3600 # convert seconds to hours
  end

  ##
  # validates average speed for trip.
  # if the average speed is less than 5 or more than 100 its not valid
  def validate_avg_speed
    avg_speed =  miles_driven / drive_time # compute average_speed

    if avg_speed < 5.0
      errors.add(:base, 'average speed is too slow (< 5 mph).')
    elsif avg_speed > 100.0
      errors.add(:base, 'average speed is too fast (> 100 mph).')
    end
  end
end
