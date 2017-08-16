RSpec.describe CommandFile do
  describe '#initialize' do
    it 'saves file path' do
      expected_path = 'some_file.txt'
      cf = CommandFile.new expected_path
      expect(cf.file_loc).to eq(expected_path)
    end
  end # initialize

  describe '#process' do
    subject(:mock_file) do
      allow(File).to receive(:open).and_return(@commands)
    end

    context 'valid command file' do
      before(:each) do
        expected_path = 'commands.txt'
        @command_file = CommandFile.new expected_path

        commands = [
          'Driver Dan',
          'Driver Alex',
          'Driver Bob',
          'Trip Dan 07:15 07:45 17.3',
          'Trip Dan 06:12 06:32 21.8',
          'Trip Alex 12:01 13:16 42.0'
        ]
        # mock File.open
        allow(File).to receive(:open).and_return(commands)
        @command_file.process
      end # before each

      it 'saves three drivers' do
        expect(Driver.count).to eq(3)
      end

      it 'saves three trips' do
        expect(Trip.count).to eq(3)
      end
    end # valid command file

    context 'invalid command file' do
      before(:each) do
        @command_file = CommandFile.new 'some_path.txt'
      end

      it 'fails with invalid command' do
        @commands = ['foo']
        mock_file
        expect { @command_file.process }
          .to raise_error(ArgumentError, "invalid command on line 1: 'foo'")
      end

      it 'fails with blank line' do
        @commands = ['']
        mock_file
        expect { @command_file.process }
          .to raise_error(ArgumentError, "invalid command on line 1: ''")
      end

      describe 'process_driver' do
        it 'fails with no driver name' do
          @commands = ['Driver']
          mock_file
          expect { @command_file.process }
            .to raise_error(ActiveRecord::RecordInvalid)
        end

        it 'fails with duplicate driver name' do
          driver1 = FactoryGirl.create :driver
          @commands = ["Driver #{driver1.name}"]
          mock_file
          expect { @command_file.process }
            .to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      describe 'process_trip' do
        it 'fails with non existant driver name' do
          @commands = ['Trip Dan 07:15 07:45 17.3']
          mock_file
          expect { @command_file.process }
            .to raise_error(
              ActiveRecord::RecordNotFound, "Couldn't find Driver"
            )
        end
        it 'fails with 1 missing time' do
          @commands = ['Trip Dan 07:45 17.3']
          mock_file
          expect { @command_file.process }
            .to raise_error(ArgumentError, "invalid strptime format - `%H:%M'")
        end

        it 'fails with 2 missing times' do
          @commands = ['Trip Dan 17.3']
          mock_file
          expect { @command_file.process }
            .to raise_error(ArgumentError, "invalid strptime format - `%H:%M'")
        end

        it 'fails with missing miles_driven' do
          driver = FactoryGirl.create :driver
          @commands = ["Trip #{driver.name} 07:15 07:45"]
          mock_file
          expect { @command_file.process }
            .to raise_error(ActiveRecord::RecordInvalid)
        end
      end # process_trip
    end # invalid command file
  end # process

  describe '#report' do
    it 'returns correct output' do
      command_file = CommandFile.new 'some_path.txt'

      jacob = FactoryGirl.create :driver, name: 'Jacob'
      FactoryGirl.create :trip,
                         driver: jacob, miles_driven: 60, start_time: Time.now,
                         end_time: Time.now + (2.5 * 3600)

      megan = FactoryGirl.create :driver, name: 'Megan'
      FactoryGirl.create :trip,
                         driver: megan, miles_driven: 42, start_time: Time.now,
                         end_time: Time.now + (2 * 3600)

      FactoryGirl.create :driver, name: 'Ari'

      expected_output = [
        'Jacob: 60 miles @ 24 mph',
        'Megan: 42 miles @ 21 mph',
        'Ari: 0 miles'
      ]

      expect { command_file.report }
        .to output(expected_output.join("\n") + "\n").to_stdout
    end
  end # report
end
