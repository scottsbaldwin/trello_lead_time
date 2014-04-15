module TrelloLeadTime
  class Card
    def self.from_trello_card(trello_card)
      Card.new(trello_card)
    end

    def initialize(trello_card)
      @trello_card = trello_card
      @timeline = Timeline.for_trello_card(trello_card)
    end

    def name
      @trello_card.name
    end

    def done?
      @timeline.done?
    end

    def closed?
      @trello_card.closed
    end

    def age_in_seconds
      @timeline.age_in_seconds
    end
  end
end
