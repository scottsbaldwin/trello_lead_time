module TrelloLeadTime
  class Board

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

    private

    def find_list_by_name(name)
      if !@_lists.has_key?(name)
        trello_list = @trello_board.lists({filter: 'all'}).detect { |l| l.name == name }
        @_lists[name] = TrelloLeadTime::List.from_trello_list(trello_list) if trello_list
      end
      @_lists[name]
    end

  end
end
