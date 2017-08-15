require 'sqlite3'
require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

ActiveRecord::Schema.define do
  create_table :drivers, force: true do |t|
    t.string :name
    t.timestamps
  end

  create_table :trips, force: true do |t|
    t.references :driver
    t.datetime :start_time
    t.datetime :end_time
    t.float :drive_time
    t.float :miles_driven
    t.timestamps
  end

  # execute %w(ALTER TABLE "articles" ADD CONSTRAINT trips_driver_id_fk FOREIGN KEY ("driver_id") REFERENCES "drivers" ("id")
  # )
  add_foreign_key :trips, :drivers
end
