require 'singleton'
require 'trello'

module TrelloLeadTime
  module Config
    extend self

    def configure
      yield self
    end

  end
end
