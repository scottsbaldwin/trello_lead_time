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

    def average_age(name_of_list_with_done_cards)
      list = find_list_by_name(name_of_list_with_done_cards)
      return 0 if list.nil?
      list.average_age
    end

    def average_lead_time(name_of_list_with_done_cards)
      list = find_list_by_name(name_of_list_with_done_cards)
      return 0 if list.nil?
      list.average_lead_time
    end

    def average_queue_time(name_of_list_with_done_cards)
      list = find_list_by_name(name_of_list_with_done_cards)
      return 0 if list.nil?
      list.average_queue_time
    end

    def average_cycle_time(name_of_list_with_done_cards)
      list = find_list_by_name(name_of_list_with_done_cards)
      return 0 if list.nil?
      list.average_cycle_time
    end

    def averages(name_of_list_with_done_cards)
      list = find_list_by_name(name_of_list_with_done_cards)
      response = default_format
      return response if list.nil?

      response[:lead_time][:overall] = list.average_lead_time
      response[:queue_time][:overall] = list.average_queue_time
      response[:cycle_time][:overall] = list.average_cycle_time
      response[:age][:overall] = list.average_age
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
