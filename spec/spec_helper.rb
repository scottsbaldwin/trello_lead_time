require 'trello_lead_time'
require 'webmock/rspec'

RSpec.configure do |config|
  config.before(:suite) do
    TrelloLeadTime.configure do |cfg|
      cfg.organization_name = 'wellmatch'
      cfg.set_trello_key_and_token('key', 'token')
    end
  end
end
