FactoryGirl.define do
  factory :driver do
    name 'Jacob'
  end # driver

  factory :trip do
    driver
    start_time Time.now
    end_time Time.now + 3600
    miles_driven 10.0
  end # trip
end
