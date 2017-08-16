FactoryGirl.define do
  factory :driver do
    name 'Jacob'
  end # driver

  factory :trip do
    driver
    start_time Time.now
    end_time Time.now + 3600 # 1 hour from now
    miles_driven 10.0
  end # trip
end
