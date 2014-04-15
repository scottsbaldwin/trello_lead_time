require 'singleton'
require 'trello'

module TrelloLeadTime
  module Config
    extend self

    attr_accessor :organization_name

    def configure
      yield self
    end

  end
end
