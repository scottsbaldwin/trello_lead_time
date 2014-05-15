require 'trello_lead_time'
require 'webmock/rspec'

RSpec.configure do |config|
  config.before(:suite) do
    TrelloLeadTime.configure do |cfg|
      cfg.organization_name = 'wellmatch'
      cfg.set_trello_key_and_token('key', 'token')
      cfg.queue_time_lists = ['Product Backlog']
      cfg.cycle_time_lists = ['Development', 'Acceptance']
      cfg.finance_type_labels = ['CapEx', 'OpEx']
      cfg.list_name_matcher_for_done = /^Done/i
    end
  end
end
