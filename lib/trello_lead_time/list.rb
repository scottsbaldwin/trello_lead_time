module TrelloLeadTime
  class List
    def self.from_trello_list(list)
      List.new(list)
    end

    def initialize(list)
      @trello_list = list
    end

    def name
      @trello_list.name
    end

    def average_lead_time
      cards = done_or_closed_cards
      calculate_average_time_of_cards(cards)
    end

    private

    def done_or_closed_cards
      cards.select { |c| c.done? || c.closed? }
    end

    def cards
      @_cards ||= @trello_list.cards.map { |c| TrelloLeadTime::Card.from_trello_card(c) }
    end

    def calculate_average_time_of_cards(cards)
      times = cards.map { |c| c.age_in_seconds }
      avg = 0.0
      if times.size > 0
        avg = (times.inject(0.0) { |sum, el| sum + el } / times.size).round(0)
      end
      avg
    end
  end
end
