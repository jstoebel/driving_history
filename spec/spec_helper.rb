require 'rubygems'
require 'bundler'
Bundler.require(:default, :test)
here = File.dirname(__FILE__) # path to this file
project_root = File.join(here, '..') # project root

# load schema, models and command_file
require File.join(project_root, 'schema.rb')
require './models/driver'
require './models/trip'
require './command_file'

# make sure validation errors don't try to use another language
I18n.default_locale = 'en'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups

  # setup for Factory Girl
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    FactoryGirl.find_definitions
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
