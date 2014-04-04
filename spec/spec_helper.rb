require 'trello_lead_time'

Dir["#{File.dirname(__FILE__)}/lib/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.before(:suite) do
    TrelloLeadTime.configure do |config|
      config.public_key = 'foo'
    end
  end
end
