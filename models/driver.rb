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

end