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
    end

    def name
      @trello_board.name
    end

    def average_lead_time(name_of_list_with_done_cards)
      list = find_list_by_name(name_of_list_with_done_cards)
      return 0 if list.nil?
      list.average_lead_time
    end

    private

    def find_list_by_name(name)
      if !@_list
        trello_list = @trello_board.lists({filter: 'all'}).detect { |l| l.name == name }
        @_list = TrelloLeadTime::List.from_trello_list(trello_list) if trello_list
      end
      @_list
    end

  end
end
