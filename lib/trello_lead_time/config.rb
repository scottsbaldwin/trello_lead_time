require 'singleton'
require 'trello'

module TrelloLeadTime
  module Config
    extend self

    attr_accessor :organization_name, :queue_time_lists, :cycle_time_lists

    def configure
      yield self
    end

    def set_trello_key_and_token(key, token)
      Trello.configure do |cfg|
        cfg.developer_public_key = key
        cfg.member_token         = token
      end
    end

    def queue_time_lists
      @queue_time_lists = [] if !@queue_time_lists
      @queue_time_lists
    end

    def cycle_time_lists
      @cycle_time_lists = [] if !@cycle_time_lists
      @cycle_time_lists
    end
  end
end
