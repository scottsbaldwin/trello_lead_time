require 'singleton'
require 'trello'

module TrelloLeadTime
  module Config
    extend self

    attr_accessor :organization_name, :queue_time_lists, :cycle_time_lists, :finance_type_labels, :list_name_matcher_for_done

    def configure
      reset!
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

    def finance_type_labels
      @finance_type_labels = %w{CapEx OpEx} if !@finance_type_labels
      @finance_type_labels
    end

    def list_name_matcher_for_done
      @list_name_matcher_for_done = /^Done/i if !@list_name_matcher_for_done
      @list_name_matcher_for_done
    end
  end

  private

  def reset!
    @organization_name          = nil
    @queue_time_lists           = nil
    @cycle_time_lists           = nil
    @list_name_matcher_for_done = nil
  end
end
