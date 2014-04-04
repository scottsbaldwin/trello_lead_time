require 'singleton'

module TrelloLeadTime
  module Config
    extend self

    attr_accessor :public_key, :member_token

    def configure
      yield self
    end

  end
end
