require 'trello_lead_time'
require 'webmock/rspec'

RSpec.configure do |config|
  config.before(:suite) do
    Trello.configure do |cfg|
      cfg.developer_public_key = 'key'
      cfg.member_token         = 'token'
    end
  end
end
