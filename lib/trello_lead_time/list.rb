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
      calculate_average_age_of_cards(cards)
    end

    def average_queue_time(queue_lists)
      calculate_average_queue_time_of_cards(cards, queue_lists)
    end

    def average_cycle_time(cycle_time_lists)
      calculate_average_cycle_time_of_cards(cards, cycle_time_lists)
    end

    private

    def cards
      @_cards ||= @trello_list.cards.map { |c| TrelloLeadTime::Card.from_trello_card(c) }
    end

    def calculate_average_age_of_cards(cards)
      times = cards.map { |c| c.age_in_seconds }
      average(times)
    end

    def calculate_average_queue_time_of_cards(cards, queue_lists = [])
      times = cards.map { |c| c.queue_time(queue_lists) }
      average(times)
    end

    def calculate_average_cycle_time_of_cards(cards, cycle_time_lists = [])
      times = cards.map { |c| c.cycle_time(cycle_time_lists) }
      average(times)
    end

    def average(times)
      avg = 0.0
      if times.size > 0
        avg = (times.inject(0.0) { |sum, el| sum + el } / times.size).round(0)
      end
      avg
    end
  end
end
