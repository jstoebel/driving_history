RSpec.describe Driver do
  describe 'name' do
    it 'requires a name' do
      empty_driver = Driver.new
      empty_driver.valid?

      expect(empty_driver.errors[:name]).to include("can't be blank")
    end

    it 'disallows dupicates' do
      FactoryGirl.create :driver
      driver2 = FactoryGirl.build :driver
      driver2.valid?

      expect(driver2.errors[:name]).to include('has already been taken')
    end
  end # name

  describe '#trips' do
    it 'has_many trips' do
      driver = FactoryGirl.create :driver
      trips = FactoryGirl.create_list :trip, 2, driver: driver

      expect(driver.trips).to eq(trips)
    end
  end # trips

  describe '#report' do
    it 'generates a report for one driver' do
      FactoryGirl.create :trip
      expect(Driver.report).to eq(['Jacob: 10 miles @ 10 mph'])
    end

    it 'properly sorts drivers by miles driven (decending order)' do
      d1 = FactoryGirl.create :driver
      FactoryGirl.create :trip, driver: d1

      d2 = FactoryGirl.create :driver, name: 'Megan'
      FactoryGirl.create :trip, driver: d2, miles_driven: 20
      expect(Driver.report)
        .to eq(['Megan: 20 miles @ 20 mph', 'Jacob: 10 miles @ 10 mph'])
    end

    it "doesn't include if miles_driven == 0" do
      FactoryGirl.create :driver
      expect(Driver.report).to eq(['Jacob: 0 miles'])
    end

    it 'handles singularization' do
      # should be able to handle when miles_driven == 1
      FactoryGirl.create :trip, miles_driven: 1,
                                start_time: Time.now,
                                end_time: Time.now + 60
      expect(Driver.report).to eq(['Jacob: 1 mile @ 60 mph'])
    end
  end # report
end
