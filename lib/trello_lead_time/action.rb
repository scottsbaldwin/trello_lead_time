module TrelloLeadTime
  class Action
    def self.from_trello_action(trello_action)
      Action.new(trello_action)
    end

    def initialize(trello_action)
      @trello_action = trello_action
    end

    def type
      @trello_action.type
    end

    def data
      @trello_action.data
    end

    def date
      @trello_action.date
    end
  end
end
