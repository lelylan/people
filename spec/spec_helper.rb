require 'rubygems'
require 'spork'

# Internal. This code runs once when you run your test suite.
Spork.prefork do
  ENV['RAILS_ENV'] ||= 'test'

  require 'rails/application'
  Spork.trap_method(Rails::Application::RoutesReloader, :reload!)
  Spork.trap_method(Rails::Application, :eager_load!)

  require File.expand_path('../../config/environment', __FILE__)
  Rails.application.railties.all { |r| r.eager_load! }

  require 'rspec/rails'
  require 'capybara/rspec'
  require 'webmock/rspec'
  require 'draper/test/rspec_integration'
  require 'database_cleaner'
  require 'email_spec'

  RSpec.configure do |config|
    config.mock_with :rspec

    # Clean up the database
    config.before(:suite) { DatabaseCleaner.strategy = :truncation }
    config.before(:suite) { DatabaseCleaner.orm = :mongoid }
    config.before(:each)  { DatabaseCleaner.clean }

    # Let selenium work while blocking all requests to the net
    WebMock.disable_net_connect! allow_localhost: true
  end
end

# Internal. This code runs each time you run your specs.
Spork.each_run do
  FactoryGirl.reload
  I18n.backend.reload!
  Dir[Rails.root.join('spec/support/**/*.rb')].each {|f| require f}
  Dir[Rails.root.join('spec/requests/support/**/*.rb')].each {|f| require f}
  Dir[Rails.root.join('spec/models/concerns/**/*.rb')].each {|f| require f}
end
