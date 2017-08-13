RSpec.describe Driver do

  describe "name" do

    it "requires a name" do
      empty_driver = Driver.new
      empty_driver.valid?

      expect(empty_driver.errors[:name]).to include("can't be blank")
    end

    it "disallows dupicates" do
      driver1 = FactoryGirl.create :driver
      driver2 = FactoryGirl.build :driver
      driver2.valid?

      expect(driver2.errors[:name]).to include('has already been taken')
    end

  end # name

  describe "#trips" do
    it "has_many trips" do 
      driver = FactoryGirl.create :driver
      trips = FactoryGirl.create_list :trip, 2, :driver => driver

      expect(driver.trips).to eq(trips)
    end
  end # trips

end