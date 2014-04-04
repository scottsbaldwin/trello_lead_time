require 'trello_lead_time/config'

module TrelloLeadTime
  extend self

  def configure
    yield Config
  end
end
