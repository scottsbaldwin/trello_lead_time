module TrelloLeadTime
  class Board
    include ArraySearcher

    def self.from_url(url)
      @org = Trello::Organization.find(TrelloLeadTime::Config.organization_name)
      if @org
        @boards = @org.boards
        @board = @boards.detect { |b| b.url == url }
        return Board.new(@board) if @board
      end
      nil
    end

    def initialize(trello_board)
      @trello_board = trello_board
      @_lists = {}
    end

    def name
      @trello_board.name
    end

    def cards(name_of_list_with_done_cards)
      list = find_list_by_name(name_of_list_with_done_cards)
      response = []
      return response if list.nil?
      list.done_or_closed_cards
    end

    def totals(name_of_list_with_done_cards)
      list = find_list_by_name(name_of_list_with_done_cards)
      response = default_format
      return response if list.nil?

      response[:lead_time][:overall]  = list.total_lead_time
      response[:queue_time][:overall] = list.total_queue_time
      response[:cycle_time][:overall] = list.total_cycle_time
      response[:age][:overall]        = list.total_age

      breakdown_by_labels = list.breakdown_by_labels(Config.finance_type_labels)
      response[:lead_time][:finance_types]  = breakdown_by_labels[:total][:lead_time]
      response[:queue_time][:finance_types] = breakdown_by_labels[:total][:queue_time]
      response[:cycle_time][:finance_types] = breakdown_by_labels[:total][:cycle_time]
      response[:age][:finance_types]        = breakdown_by_labels[:total][:age]

      breakdown_by_tags = list.breakdown_by_tags
      response[:lead_time][:initiatives]  = breakdown_by_tags[:total][:lead_time]
      response[:queue_time][:initiatives] = breakdown_by_tags[:total][:queue_time]
      response[:cycle_time][:initiatives] = breakdown_by_tags[:total][:cycle_time]
      response[:age][:initiatives]        = breakdown_by_tags[:total][:age]
      response
    end

    def averages(name_of_list_with_done_cards)
      list = find_list_by_name(name_of_list_with_done_cards)
      response = default_format
      return response if list.nil?

      response[:lead_time][:overall]  = list.average_lead_time
      response[:queue_time][:overall] = list.average_queue_time
      response[:cycle_time][:overall] = list.average_cycle_time
      response[:age][:overall]        = list.average_age

      breakdown_by_labels = list.breakdown_by_labels(Config.finance_type_labels)
      response[:lead_time][:finance_types]  = breakdown_by_labels[:average][:lead_time]
      response[:queue_time][:finance_types] = breakdown_by_labels[:average][:queue_time]
      response[:cycle_time][:finance_types] = breakdown_by_labels[:average][:cycle_time]
      response[:age][:finance_types]        = breakdown_by_labels[:average][:age]

      breakdown_by_tags = list.breakdown_by_tags
      response[:lead_time][:initiatives]  = breakdown_by_tags[:average][:lead_time]
      response[:queue_time][:initiatives] = breakdown_by_tags[:average][:queue_time]
      response[:cycle_time][:initiatives] = breakdown_by_tags[:average][:cycle_time]
      response[:age][:initiatives]        = breakdown_by_tags[:average][:age]
      response
    end

    private

    def find_list_by_name(name)
      matched_name = find_name_like(@_lists.keys, name)
      if matched_name.nil?
        trello_list = @trello_board.lists({filter: 'all'}).detect { |l| element_matches_expression?(l.name, name) }
        @_lists[name] = TrelloLeadTime::List.from_trello_list(trello_list) if trello_list
      end
      @_lists[name]
    end

    def default_format
      {
        lead_time: default_entry,
        queue_time: default_entry,
        cycle_time: default_entry,
        age: default_entry,
      }
    end

    def default_entry
      {
        overall: 0,
        initiatives: {},
        finance_types: {}
      }
    end

  end
end
