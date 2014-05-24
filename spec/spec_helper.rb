require 'simplecov'
require 'coveralls'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

# All other 'requires' must come in after simplecov

require 'scrapey'
require 'webmock/rspec'

RSpec.configure do |config|

  config.before :all do
    Scrapey.logger.level = Logger::FATAL
  end

  config.after :all do
    Scrapey.logger = nil
  end
end
