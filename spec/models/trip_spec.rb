RSpec.describe Trip do
  describe '#driver' do
    before(:each) do
      @trip = FactoryGirl.build :trip
    end
    # ensure the #driver method works
    it 'pulls the driver' do
      @trip.save
      expected_driver = Driver.find @trip.driver_id
      expect(expected_driver).to eq(@trip.driver)
    end
  end # driver

  describe 'basic validations' do
    before(:each) do
      @trip = FactoryGirl.build :trip
    end
    # ensure that each attr is required
    %i[driver_id start_time end_time miles_driven].each do |attr|
      it "requires #{attr}" do
        blank_trip = Trip.new
        blank_trip.valid?
        errors = blank_trip.errors
        expect(errors[attr]).to include("can't be blank")
      end
    end

    # check that these attributes require numericality
    %i[driver_id miles_driven].each do |attr|
      it "requires a number for #{attr}" do
        @trip[attr] = 'not a number'
        @trip.valid?
        expect(@trip.errors[attr]).to include('is not a number')
      end
    end

    # check that miles_driven is > 0
    it 'requires miles_driven to be positive number' do
      @trip.miles_driven = -1
      @trip.valid?
      expect(@trip.errors[:miles_driven]).to include('must be greater than 0')
    end
  end # basic_validations

  describe '#get_drive_time' do
    before(:each) do
      @trip = FactoryGirl.build :trip
    end

    it 'computes drive time' do
      @trip.save
      expected_drive_time = (@trip.end_time - @trip.start_time) / 3600
      expect(expected_drive_time).to eq(@trip.drive_time)
    end

    # check speed uper and lower bounds
    it "isn't valid if avg speed > 100 mph" do
      @trip.miles_driven = 101
      @trip.valid?
      expect(@trip.errors[:base])
        .to eq(['average speed is too fast (> 100 mph).'])
    end

    it "isn't valid if avg speed < 5 mpg" do
      @trip.miles_driven = 4
      @trip.valid?
      expect(@trip.errors[:base])
        .to eq(['average speed is too slow (< 5 mph).'])
    end
  end # get_drive_time
end
