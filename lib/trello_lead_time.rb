require 'trello'
Dir["#{File.dirname(__FILE__)}/trello_lead_time/**/*.rb"].each { |f| require f }

module TrelloLeadTime
  extend self

  def configure
    yield Config
  end
end
