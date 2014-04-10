module TrelloLeadTime
  class Board
    def self.for(id)
      b = Trello::Board.find(id)
      Board.new(b)
    end

    def initialize(trello_board)
      @trello_board = trello_board
    end

    def name
      @trello_board.name
    end

  end
end
