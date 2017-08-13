RSpec.describe CommandFile do

  describe "#initialize" do
    it "saves file path" do
      expected_path = 'some_file.txt'
      cf = CommandFile.new expected_path
      expect(cf.file_loc).to eq(expected_path)
    end
  end # initialize

  describe "#process" do

    context "valid command file" do
      before(:each) do
        expected_path = "commands.txt"
        @command_file = CommandFile.new expected_path

        commands = [
          "Driver Dan",
          "Driver Alex",
          "Driver Bob",
          "Trip Dan 07:15 07:45 17.3",
          "Trip Dan 06:12 06:32 21.8",
          "Trip Alex 12:01 13:16 42.0"
        ]
        # mock File.open
        allow(File).to receive(:open).and_return(commands)
        @command_file.process
      end # before each

      it "saves three drivers" do
        expect(Driver.count).to eq(3)
      end

      it "saves three trips" do
        expect(Trip.count).to eq(3)
      end

    end # valid command file

    context "invalid command file" do

      before(:each) do
        expected_path = "commands.txt"
        @command_file = CommandFile.new expected_path

        # commands = [
        #   "Driver Dan",
        #   "Driver Alex",
        #   "Driver Bob",
        #   "Trip Dan 07:15 07:45 17.3",
        #   "Trip Dan 06:12 06:32 21.8",
        #   "Trip Alex 12:01 13:16 42.0"
        # ]
        # mock File.open
        allow(File).to receive(:open).and_return(commands)
        @command_file.process
      end # before each

      it "fails with no driver name" do

      end

      it "fails with duplicate driver name" do

      end

      [:start_time, :end_time].each do |attr|
        it "fails with missing #{attr}" do

        end

        it "fails with poorly formatted #{attr}" do
          
        end
      end

      it "fails with missing miles_driven" do

      end



    end # invalid command file

  end # process

end